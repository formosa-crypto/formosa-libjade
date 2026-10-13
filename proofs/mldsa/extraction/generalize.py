#!/usr/bin/env python3
"""Turn the jasmin2ec models Mldsa{44,65,87}.ec into one generic abstract
theory MldsaT, plus one instance file per parameter set that realizes the
generic module M by that set's extracted module.

The models have the same shape: they differ only at integer leaves and at
Array<N>/WArray<N> theory names. This script
  1. tokenises the module bodies and collects the differing positions (the
     token counts must agree),
  2. maps every differing leaf to a role: a named quantity whose tuple of
     values over the sets matches the leaf's tuple,
  3. writes ../generic/LayoutT.ec: the base parameters (abstract operators),
     the derived sizes (definitions), and one symbolic PolyArray/WArray clone
     per array role,
  4. writes ../generic/MldsaT.ec: the module body with the leaves replaced by
     the role names,
  5. writes ../generic/Mldsa<set>I.ec: a clone of MldsaT that realizes the
     base parameters by literals, the array theories by Array<N>/WArray<N>,
     and the module M by Mldsa<set>.M.
EasyCrypt accepts `module M <= Mldsa<set>.M` only if the generic body, with
the parameters of the set substituted, is convertible to the extracted body:
each instance file compiling is the statement that MldsaT is that model.
"""

import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC  = os.path.abspath(os.path.join(HERE, "..", "..", "..", "src", "mldsa", "avx2"))
OUT  = os.path.abspath(os.path.join(HERE, "..", "generic"))
SETS = [44, 65, 87]

TOKRE = re.compile(r"[A-Za-z_][A-Za-z_0-9']*|\d+|\S")
ARRRE = re.compile(r"^(W?Array)(\d+)$")

# ---------------------------------------------------------------------------
# parameter values, per set, evaluated from the Jasmin parameter files
# ---------------------------------------------------------------------------
def jasmin_params(k):
    env = {}
    for f in (os.path.join(SRC, "common", "constants.jinc"),
              os.path.join(SRC, str(k), "parameters.jinc")):
        txt = re.sub(r"//.*", "", open(f).read())
        for name, expr in re.findall(r"param\s+int\s+(\w+)\s*=\s*([^;]+);", txt, re.S):
            expr = re.sub(r"(\d)_(\d)", r"\1\2", expr.strip())
            env[name] = eval("(" + re.sub(r"/", "//", expr) + ")", {}, dict(env))
    return env

PAR = {k: jasmin_params(k) for k in SETS}

def log2(x):
    n = 0
    while (1 << n) < x: n += 1
    assert (1 << n) == x, x
    return n

# ---------------------------------------------------------------------------
# the role table: (name, EasyCrypt definition or None for a base parameter,
#                  Jasmin name(s), value)
# ---------------------------------------------------------------------------
ROLES = [
 # base parameters: abstract operators, realized by literals per set
 ("kvec",       None, "ROWS_IN_MATRIX_A",                lambda p: p["ROWS_IN_MATRIX_A"]),
 ("lvec",       None, "COLUMNS_IN_MATRIX_A",             lambda p: p["COLUMNS_IN_MATRIX_A"]),
 ("eta_max",    None, "ETA",                             lambda p: p["ETA"]),
 ("tau",        None, "ONES_IN_VERIFIER_CHALLENGE",      lambda p: p["ONES_IN_VERIFIER_CHALLENGE"]),
 ("omega",      None, "MAX_ONES_IN_HINT",                lambda p: p["MAX_ONES_IN_HINT"]),
 ("ctilde",     None, "COMMITMENT_HASH_SIZE",            lambda p: p["COMMITMENT_HASH_SIZE"]),
 ("gamma1_log", None, "GAMMA1 = 1 << gamma1_log",        lambda p: log2(p["GAMMA1"])),
 ("gamma2_div", None, "GAMMA2 = (MODULUS - 1) / gamma2_div",
                                                         lambda p: (p["MODULUS"] - 1) // p["GAMMA2"]),
 ("rej_bound",  None, "ERROR_REJECTION_BOUND",           lambda p: p["ERROR_REJECTION_BOUND"]),
 ("eta_bits",   None, "BITS_PER_ERROR_COEFFICIENT",      lambda p: p["ENCODED_ERROR_POLYNOMIAL_SIZE"] * 8 // 256),
 ("w1_bits",    None, "BITS_PER_COMMITMENT_COEFFICIENT", lambda p: p["BITS_PER_COMMITMENT_COEFFICIENT"]),
 # derived sizes
 ("gamma1_bits", "gamma1_log + 1",      "BITS_TO_ENCODE_GAMMA1_COEFFICIENT",
                                         lambda p: p["BITS_TO_ENCODE_GAMMA1_COEFFICIENT"]),
 ("eta_enc",    "32 * eta_bits",        "ENCODED_ERROR_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_ERROR_POLYNOMIAL_SIZE"]),
 ("w1_enc",     "32 * w1_bits",         "ENCODED_COMMITMENT_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_COMMITMENT_POLYNOMIAL_SIZE"]),
 ("gamma1_enc", "32 * gamma1_bits",     "ENCODED_GAMMA1_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_GAMMA1_POLYNOMIAL_SIZE"]),
 ("z_enc",      "lvec * gamma1_enc",    "GAMMA1_ENCODED_SIZE", lambda p: p["GAMMA1_ENCODED_SIZE"]),
 ("s1_enc",     "lvec * eta_enc",       "S1_ENCODED_SIZE",     lambda p: p["S1_ENCODED_SIZE"]),
 ("s2_enc",     "kvec * eta_enc",       "S2_ENCODED_SIZE",     lambda p: p["S2_ENCODED_SIZE"]),
 ("t1_enc",     "kvec * 320",           "T1_ENCODED_SIZE",     lambda p: p["T1_ENCODED_SIZE"]),
 ("t0_enc",     "kvec * 416",           "T0_ENCODED_SIZE",     lambda p: p["T0_ENCODED_SIZE"]),
 ("hint_enc",   "omega + kvec",         "HINT_ENCODED_SIZE",   lambda p: p["HINT_ENCODED_SIZE"]),
 ("w1vec_enc",  "kvec * w1_enc",        "ENCODED_COMMITMENT_SIZE",
                                         lambda p: p["ENCODED_COMMITMENT_SIZE"]),
 ("pk_bytes",   "32 + t1_enc",          "VERIFICATION_KEY_SIZE",
                                         lambda p: p["VERIFICATION_KEY_SIZE"]),
 ("sk_bytes",   "128 + s1_enc + s2_enc + t0_enc", "SIGNING_KEY_SIZE",
                                         lambda p: p["SIGNING_KEY_SIZE"]),
 ("sig_bytes",  "ctilde + z_enc + hint_enc", "SIGNATURE_SIZE", lambda p: p["SIGNATURE_SIZE"]),
 ("lpolys",     "lvec * 256",           "COLUMNS_IN_MATRIX_A * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["COLUMNS_IN_MATRIX_A"] * 256),
 ("kpolys",     "kvec * 256",           "ROWS_IN_MATRIX_A * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["ROWS_IN_MATRIX_A"] * 256),
 ("klpolys",    "kvec * lvec * 256",    "ROWS * COLUMNS * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["ROWS_IN_MATRIX_A"] * p["COLUMNS_IN_MATRIX_A"] * 256),
 ("lpolys_bytes", "4 * lpolys",         "bytes of an L-vector of u32 polynomials",
                                         lambda p: 4 * p["COLUMNS_IN_MATRIX_A"] * 256),
]
ROLE = {r[0]: r for r in ROLES}

def role_tuple(name):
    return tuple(ROLE[name][3](PAR[k]) for k in SETS)

ROLE_OF_TUPLE, ALIASES = {}, {}
for r in ROLES:
    t = role_tuple(r[0])
    ALIASES.setdefault(t, []).append(r[0])
    ROLE_OF_TUPLE.setdefault(t, r[0])
ALIASES = {t: ns for t, ns in ALIASES.items() if len(ns) > 1}

# ---------------------------------------------------------------------------
def header_abbrevs(head):
    """The global constants of a model: its text from the first `abbrev'."""
    i = head.find("abbrev ")
    return "" if i < 0 else head[i:]

def read_model(k):
    txt = open(os.path.join(HERE, "Mldsa%d.ec" % k)).read()
    blank = re.sub(r"\(\*.*?\*\)", lambda mo: " " * len(mo.group(0)), txt, flags=re.S)
    i = blank.index("module M = {")
    toks = [(mo.group(0), mo.start() - i, mo.end() - i) for mo in TOKRE.finditer(blank, i)]
    return txt[:i], txt[i:], toks

def context(toks, i):
    for j in range(i, -1, -1):
        if toks[j][0] == "proc": return toks[j + 1][0]
    return "<module header>"

def arrkey(nm):
    mo = ARRRE.match(nm); return (mo.group(1), int(mo.group(2)))

def wrap_require(names):
    line, lines = "require import", []
    for nm in names:
        if len(line) + 1 + len(nm) > 78:
            lines.append(line); line = " " + nm
        else:
            line += " " + nm
    lines.append(line + ".")
    return "\n".join(lines) + "\n"

def write(name, s):
    path = os.path.join(OUT, name)
    open(path, "w").write(s)
    print("wrote %s (%d bytes)" % (path, len(s)))

GEN = "(* GENERATED by proofs/mldsa/extraction/generalize.py -- do not edit. *)\n"

def main():
    models = {k: read_model(k) for k in SETS}
    head, body, toks = models[SETS[0]]
    n = len(toks)
    for k in SETS:
        if len(models[k][2]) != n:
            sys.exit("token count mismatch: %d has %d tokens, %d has %d"
                     % (k, len(models[k][2]), SETS[0], n))

    abbrevs = header_abbrevs(head)
    for k in SETS:
        if header_abbrevs(models[k][0]) != abbrevs:
            sys.exit("the global constants of Mldsa%d differ from Mldsa%d's" % (k, SETS[0]))
    const_hdr = set(re.findall(r"\bW?Array\d+\b", abbrevs))

    pvars = set(re.findall(r"\b([a-zA-Z_][A-Za-z_0-9']*)\s*:\s*(?:int|bool|W\d+\.t)", body))
    clash = sorted(r for r in ROLE if r in pvars)
    if clash:
        sys.exit("role names used as program variables: %s" % clash)

    subst, const_arr, sym_arr, used, errors = [], set(), {}, set(), []
    for i in range(n):
        vals = tuple(models[k][2][i][0] for k in SETS)
        tok, s, e = toks[i]
        if len(set(vals)) == 1:
            if ARRRE.match(tok): const_arr.add(tok)
            continue
        if all(v.isdigit() for v in vals):
            kind, key = "int", tuple(int(v) for v in vals)
        else:
            mos = [ARRRE.match(v) for v in vals]
            if not all(mos) or len(set(mo.group(1) for mo in mos)) != 1:
                errors.append("unexplained difference in %s: %s" % (context(toks, i), vals))
                continue
            kind, key = mos[0].group(1), tuple(int(mo.group(2)) for mo in mos)
        role = ROLE_OF_TUPLE.get(key)
        if role is None:
            errors.append("no role for %s %s in %s" % (kind, key, context(toks, i)))
            continue
        used.add(role)
        if kind == "int":
            subst.append((s, e, role))
        else:
            sym_arr[(kind, role)] = {k: vals[j] for j, k in enumerate(SETS)}
            subst.append((s, e, "%s_%s" % (kind, role)))
    if errors:
        for m in errors[:40]: print("ERROR:", m, file=sys.stderr)
        sys.exit("%d unexplained leaves" % len(errors))

    # every role, closed under the dependencies of the definitions
    needed = set(used) | {r[0] for r in ROLES if r[1] is None}
    changed = True
    while changed:
        changed = False
        for name, ecdef, _, _ in ROLES:
            if name in needed and ecdef:
                for dep in re.findall(r"[A-Za-z_]\w*", ecdef):
                    if dep in ROLE and dep not in needed:
                        needed.add(dep); changed = True

    out, prev = [], 0
    for s, e, rep in subst:
        out.append(body[prev:s]); out.append(rep); prev = e
    out.append(body[prev:])
    generic_body = "".join(out)

    os.makedirs(OUT, exist_ok=True)
    arrays = sorted(sym_arr, key=lambda x: (x[1], x[0]))
    emit_layout(needed, arrays)
    emit_generic(abbrevs + generic_body, const_arr | const_hdr, arrays)
    for k in SETS:
        emit_instance(k, needed, sym_arr, arrays)

    print("roles (%d):" % len(needed))
    for name, ecdef, jas, _ in ROLES:
        if name in needed:
            print("  %-12s = %-32s %s" % (name, ecdef or "(base)", role_tuple(name)))
    print("symbolic array theories (%d)" % len(arrays))
    if ALIASES: print("alias classes:", ALIASES)

def role_comment(needed):
    L = ["(* Vocabulary: every leaf of the models that varies with the\n",
         "   parameter set is one of these. Values for ML-DSA-44/65/87, and\n",
         "   the Jasmin parameter each one stands for:\n"]
    for name, ecdef, jas, _ in ROLES:
        if name in needed:
            L.append("     %-12s %-18s %s\n" % (name, "%s" % (role_tuple(name),), jas))
    L.append("*)\n")
    return "".join(L)

def emit_layout(needed, arrays):
    L = [GEN, "require import AllCore IntDiv.\n",
         "from Jasmin require import JArray JWord_array.\n\n",
         role_comment(needed), "\nabstract theory LayoutT.\n\n",
         "(* the base parameters of the implementation *)\n"]
    for name, ecdef, _, _ in ROLES:
        if name in needed and ecdef is None:
            L.append("op %s : int.\n" % name)
    L.append("\n")
    for name, ecdef, _, _ in ROLES:
        if name in needed and ecdef is None:
            L.append("axiom ge0_%s : 0 <= %s.\n" % (name, name))
    L.append("\n(* the derived sizes *)\n")
    for name, ecdef, _, _ in ROLES:
        if name in needed and ecdef:
            L.append("op %s : int = %s.\n" % (name, ecdef))
    L.append("\n")
    for name, ecdef, _, _ in ROLES:
        if name in needed and ecdef:
            deps = [d for d in re.findall(r"[A-Za-z_]\w*", ecdef) if d in ROLE]
            L.append("lemma ge0_%s : 0 <= %s.\nproof. by rewrite /%s; smt(%s). qed.\n"
                     % (name, name, name, " ".join("ge0_" + d for d in deps)))
    L.append("\n(* the array theories whose size varies with the parameter set *)\n")
    for kind, role in arrays:
        base = "PolyArray" if kind == "Array" else "WArray"
        L.append("clone %s as %s_%s with op size <- %s\n  proof ge0_size by exact ge0_%s.\n"
                 % (base, kind, role, role, role))
    L.append("\nend LayoutT.\n")
    write("LayoutT.ec", "".join(L))

def emit_generic(body, const_arr, arrays):
    L = [GEN,
         "(* The generic form of the models Mldsa{44,65,87}.ec: one module M *)\n",
         "(* whose varying leaves are the operators of LayoutT. The instance  *)\n",
         "(* files realize it by each model.                                  *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n\nimport SLH64.\n\n"]
    if const_arr:
        L.append(wrap_require(sorted(const_arr, key=arrkey)))
    L.append("require LayoutT.\n\nabstract theory MldsaT.\n\nclone include LayoutT.LayoutT.\n\n")
    for kind, role in arrays:
        L.append("import %s_%s.\n" % (kind, role))
    L.append("\n" + body + "\nend MldsaT.\n")
    write("MldsaT.ec", "".join(L))

def emit_instance(k, needed, sym_arr, arrays):
    arrs = sorted(set(sym_arr[a][k] for a in arrays), key=arrkey)
    L = [GEN,
         "(* ML-DSA-%d: the instance of MldsaT whose module M is the model     *)\n" % k,
         "(* Mldsa%d.M. EasyCrypt accepts `module M <= Mldsa%d.M' only when     *)\n" % (k, k),
         "(* the generic body, at these parameters, is convertible to the     *)\n",
         "(* extracted body.                                                  *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n",
         "require import Mldsa%d.\n" % k, wrap_require(arrs), "require MldsaT.\n\n",
         "clone MldsaT.MldsaT as Mldsa%dI with\n" % k]
    items = []
    base = [r for r in ROLES if r[0] in needed and r[1] is None]
    for name, _, _, fn in base:
        items.append("  op %s <= %d" % (name, fn(PAR[k])))
    for kind, role in arrays:
        items.append("  theory %s_%s <= %s" % (kind, role, sym_arr[(kind, role)][k]))
    items.append("  module M <= Mldsa%d.M" % k)
    L.append(",\n".join(items))
    L.append("\nproof\n%s.\n" % ",\n".join("  ge0_%s by done" % r[0] for r in base))
    write("Mldsa%dI.ec" % k, "".join(L))

if __name__ == "__main__":
    main()
