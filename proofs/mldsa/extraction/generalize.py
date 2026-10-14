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
  3. writes ../generic/LayoutT.ec: over the specification parameters
     P = Parameters.ParamsT, the derived sizes (definitions), and one
     symbolic PolyArray/WArray clone per array role; a base role is an
     expression over P, written into the body as is,
  4. writes ../generic/MldsaConstants.ec, the constant tables (the same in
     every model), and ../generic/MldsaT.ec: the module body with the leaves
     replaced by the role names,
  5. writes ../generic/Mldsa<set>I.ec: a clone of MldsaT that realizes P
     by Spec<set>.Params<set>, the array theories by Array<N>/WArray<N>, and
     the module M by Mldsa<set>.M.
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
# the role table: (name, EasyCrypt definition, Jasmin name(s), value). A
# definition that is a name of P (a base role) is written into the body as
# is; the others are operators of LayoutT.
# ---------------------------------------------------------------------------
ROLES = [
 # base roles: the specification parameters, and their bit widths
 ("kvec",       "P.kvec",        "ROWS_IN_MATRIX_A",                lambda p: p["ROWS_IN_MATRIX_A"]),
 ("lvec",       "P.lvec",        "COLUMNS_IN_MATRIX_A",             lambda p: p["COLUMNS_IN_MATRIX_A"]),
 ("eta_max",    "P.Eta",         "ETA",                             lambda p: p["ETA"]),
 ("tau",        "P.tau",         "ONES_IN_VERIFIER_CHALLENGE",      lambda p: p["ONES_IN_VERIFIER_CHALLENGE"]),
 ("omega",      "P.w_hint",      "MAX_ONES_IN_HINT",                lambda p: p["MAX_ONES_IN_HINT"]),
 ("gamma1_log", "P.gamma1_log",  "GAMMA1 = 1 << gamma1_log",        lambda p: log2(p["GAMMA1"])),
 ("gamma2_div", "P.gamma2_div",  "GAMMA2 = (MODULUS - 1) / gamma2_div",
                                                         lambda p: (p["MODULUS"] - 1) // p["GAMMA2"]),
 ("eta_bits",   "P.noise_bits",  "BITS_PER_ERROR_COEFFICIENT",      lambda p: p["ENCODED_ERROR_POLYNOMIAL_SIZE"] * 8 // 256),
 ("w1_bits",    "P.w1_bits",     "BITS_PER_COMMITMENT_COEFFICIENT", lambda p: p["BITS_PER_COMMITMENT_COEFFICIENT"]),
 ("gamma1_bits", "P.gamma1_bits", "BITS_TO_ENCODE_GAMMA1_COEFFICIENT",
                                         lambda p: p["BITS_TO_ENCODE_GAMMA1_COEFFICIENT"]),
 # the operators of LayoutT
 ("ctilde",     "P.lambda %/ 4", "COMMITMENT_HASH_SIZE",            lambda p: p["COMMITMENT_HASH_SIZE"]),
 ("rej_bound",  "if P.Eta = 2 then 15 else 9", "ERROR_REJECTION_BOUND",
                                                         lambda p: p["ERROR_REJECTION_BOUND"]),
 ("eta_enc",    "32 * P.noise_bits",    "ENCODED_ERROR_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_ERROR_POLYNOMIAL_SIZE"]),
 ("w1_enc",     "32 * P.w1_bits",       "ENCODED_COMMITMENT_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_COMMITMENT_POLYNOMIAL_SIZE"]),
 ("gamma1_enc", "32 * P.gamma1_bits",   "ENCODED_GAMMA1_POLYNOMIAL_SIZE",
                                         lambda p: p["ENCODED_GAMMA1_POLYNOMIAL_SIZE"]),
 ("z_enc",      "P.lvec * gamma1_enc",  "GAMMA1_ENCODED_SIZE", lambda p: p["GAMMA1_ENCODED_SIZE"]),
 ("s1_enc",     "P.lvec * eta_enc",     "S1_ENCODED_SIZE",     lambda p: p["S1_ENCODED_SIZE"]),
 ("s2_enc",     "P.kvec * eta_enc",     "S2_ENCODED_SIZE",     lambda p: p["S2_ENCODED_SIZE"]),
 ("t1_enc",     "P.kvec * 320",         "T1_ENCODED_SIZE",     lambda p: p["T1_ENCODED_SIZE"]),
 ("t0_enc",     "P.kvec * 416",         "T0_ENCODED_SIZE",     lambda p: p["T0_ENCODED_SIZE"]),
 ("hint_enc",   "P.w_hint + P.kvec",    "HINT_ENCODED_SIZE",   lambda p: p["HINT_ENCODED_SIZE"]),
 ("w1vec_enc",  "P.kvec * w1_enc",      "ENCODED_COMMITMENT_SIZE",
                                         lambda p: p["ENCODED_COMMITMENT_SIZE"]),
 ("pk_enc",     "32 + t1_enc",          "VERIFICATION_KEY_SIZE",
                                         lambda p: p["VERIFICATION_KEY_SIZE"]),
 ("sk_enc",     "128 + s1_enc + s2_enc + t0_enc", "SIGNING_KEY_SIZE",
                                         lambda p: p["SIGNING_KEY_SIZE"]),
 ("sig_enc",    "ctilde + z_enc + hint_enc", "SIGNATURE_SIZE", lambda p: p["SIGNATURE_SIZE"]),
 ("lpolys",     "P.lvec * 256",         "COLUMNS_IN_MATRIX_A * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["COLUMNS_IN_MATRIX_A"] * 256),
 ("kpolys",     "P.kvec * 256",         "ROWS_IN_MATRIX_A * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["ROWS_IN_MATRIX_A"] * 256),
 ("klpolys",    "P.kvec * P.lvec * 256", "ROWS * COLUMNS * COEFFICIENTS_IN_POLYNOMIAL",
                                         lambda p: p["ROWS_IN_MATRIX_A"] * p["COLUMNS_IN_MATRIX_A"] * 256),
 ("lpolys_bytes", "4 * lpolys",         "bytes of an L-vector of u32 polynomials",
                                         lambda p: 4 * p["COLUMNS_IN_MATRIX_A"] * 256),
]
ROLE = {r[0]: r for r in ROLES}

def is_base(name):
    """a base role: a parameter of P, or one of its bit widths"""
    return re.fullmatch(r"P\.\w+", ROLE[name][1]) is not None

def deps(ecdef):
    """the operators of LayoutT a definition mentions"""
    return [d for d in re.findall(r"(?<![.\w])[A-Za-z_]\w*", ecdef) if d in ROLE]

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
            subst.append((s, e, ROLE[role][1] if is_base(role) else role))
        else:
            sym_arr[(kind, role)] = {k: vals[j] for j, k in enumerate(SETS)}
            subst.append((s, e, "%s_%s" % (kind, role)))
    if errors:
        for m in errors[:40]: print("ERROR:", m, file=sys.stderr)
        sys.exit("%d unexplained leaves" % len(errors))

    # every role, closed under the dependencies of the definitions
    needed = set(used)
    changed = True
    while changed:
        changed = False
        for name, ecdef, _, _ in ROLES:
            if name in needed:
                for dep in deps(ecdef):
                    if dep not in needed:
                        needed.add(dep); changed = True

    out, prev = [], 0
    for s, e, rep in subst:
        out.append(body[prev:s]); out.append(rep); prev = e
    out.append(body[prev:])
    generic_body = "".join(out)

    os.makedirs(OUT, exist_ok=True)
    arrays = sorted(sym_arr, key=lambda x: (x[1], x[0]))
    emit_layout(needed, arrays)
    emit_constants(abbrevs, const_hdr)
    emit_generic(generic_body, const_arr | const_hdr, arrays)
    for k in SETS:
        emit_instance(k, needed, sym_arr, arrays)

    print("roles (%d):" % len(needed))
    for name, ecdef, jas, _ in ROLES:
        if name in needed:
            print("  %-12s = %-32s %s" % (name, ecdef, role_tuple(name)))
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
    L = [GEN, "require import AllCore IntDiv List.\n",
         "from Jasmin require import JArray JWord_array.\n",
         "require Parameters.\n\n",
         role_comment(needed), "\nabstract theory LayoutT.\n\n",
         "(* the specification parameters *)\n",
         "clone import Parameters.ParamsT as P.\n\n",
         "(* the derived sizes *)\n"]
    for name, ecdef, _, _ in ROLES:
        if name in needed and not is_base(name):
            L.append("op %s : int = %s.\n" % (name, ecdef))
    L.append("\n")
    for name, ecdef, _, _ in ROLES:
        if name not in needed: continue
        if is_base(name):
            L.append("lemma ge0_%s : 0 <= %s by smt(P.param_sets).\n" % (name, ecdef))
        else:
            L.append("lemma ge0_%s : 0 <= %s.\nproof. by rewrite /%s; smt(%s). qed.\n"
                     % (name, name, name, " ".join(["P.param_sets"] + ["ge0_" + d for d in deps(ecdef)])))
    L.append("\n(* the array theories whose size varies with the parameter set *)\n")
    for kind, role in arrays:
        base = "PolyArray" if kind == "Array" else "WArray"
        size = ROLE[role][1] if is_base(role) else role
        L.append("clone %s as %s_%s with op size <- %s\n  proof ge0_size by exact ge0_%s.\n"
                 % (base, kind, role, size, role))
    L.append("\nend LayoutT.\n")
    write("LayoutT.ec", "".join(L))

def emit_constants(abbrevs, const_hdr):
    L = [GEN,
         "(* The constant tables of the models Mldsa{44,65,87}.ec, the same *)\n",
         "(* for every parameter set.                                        *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n\n"]
    if const_hdr:
        L.append(wrap_require(sorted(const_hdr, key=arrkey)))
    L.append("\n" + abbrevs)
    write("MldsaConstants.ec", "".join(L))

def emit_generic(body, const_arr, arrays):
    L = [GEN,
         "(* The generic form of the models Mldsa{44,65,87}.ec: one module M *)\n",
         "(* whose varying leaves are the operators of LayoutT. The instance  *)\n",
         "(* files realize it by each model.                                  *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n\nimport SLH64.\n\n"]
    if const_arr:
        L.append(wrap_require(sorted(const_arr, key=arrkey)))
    L.append("require import MldsaConstants.\nrequire LayoutT.\n\n"
             "abstract theory MldsaT.\n\nclone include LayoutT.LayoutT.\n\n")
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
         "require import Mldsa%d.\n" % k, wrap_require(arrs),
         "require Spec%d MldsaT.\n\n" % k,
         "clone MldsaT.MldsaT as Mldsa%dI with\n" % k]
    items = ["  theory P <= Spec%d.Params%d" % (k, k)]
    for kind, role in arrays:
        items.append("  theory %s_%s <= %s" % (kind, role, sym_arr[(kind, role)][k]))
    items.append("  module M <= Mldsa%d.M" % k)
    L.append(",\n".join(items))
    L.append(".\n")
    write("Mldsa%dI.ec" % k, "".join(L))

if __name__ == "__main__":
    main()
