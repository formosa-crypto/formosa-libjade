#!/usr/bin/env python3
"""Turn the jasmin2ec models {512,768,1024}/Jkem_avx2.ec into one generic
abstract theory JkemT, plus one instance file per parameter set that
realizes the generic module M by that set's extracted module.

The models have the same shape: they differ only at integer leaves, at
Array<N>/WArray<N> theory names, in the order of a few local variable
declarations, and in the per-set constant tables. This script
  1. tokenises the module bodies (local declarations sorted by name) and
     collects the differing positions (the token counts must agree),
  2. maps every differing leaf to a role: a named quantity whose tuple of
     values over the sets matches the leaf's tuple,
  3. writes ../../generic/LayoutT.ec: over the specification parameters
     P = Parameters.ParamsT, the derived sizes (definitions), and one
     symbolic PolyArray/WArray clone per array role,
  4. writes ../../generic/JkemConstants.ec, the constant tables that are the
     same in every model, and ../../generic/JkemT.ec: the per-set tables as
     operators, and the module body with the leaves replaced by the roles,
  5. writes ../../avx2/<set>/Jkem<set>I.ec: a clone of JkemT that realizes P
     by Spec<set>.Params<set>, the array theories by Array<N>/WArray<N>, the
     tables by the model's, and the module M by Jkem_avx2.M.
EasyCrypt accepts `module M <= Jkem_avx2.M' only if the generic body, with
the parameters of the set substituted, is convertible to the extracted body:
each instance file compiling is the statement that JkemT is that model.
"""

import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC  = os.path.abspath(os.path.join(HERE, "..", "..", "..", "..", "src", "mlkem", "avx2"))
GEN_DIR  = os.path.abspath(os.path.join(HERE, "..", "..", "generic"))
INST_DIR = os.path.abspath(os.path.join(HERE, "..", "..", "avx2"))
SETS = [512, 768, 1024]

TOKRE = re.compile(r"[A-Za-z_][A-Za-z_0-9']*|\d+|\S")
ARRRE = re.compile(r"^(W?Array)(\d+)$")

# ---------------------------------------------------------------------------
# parameter values, per set, evaluated from the Jasmin parameter files
# ---------------------------------------------------------------------------
def jasmin_params(k):
    env = {}
    for f in (os.path.join(SRC, str(k), "params.jinc"),
              os.path.join(SRC, "common", "params.jinc")):
        txt = re.sub(r"//.*", "", re.sub(r"/\*.*?\*/", "", open(f).read(), flags=re.S))
        for name, expr in re.findall(r"param\s+int\s+(\w+)\s*=\s*([^;]+);", txt, re.S):
            env[name] = eval("(" + re.sub(r"/", "//", expr.strip()) + ")", {}, dict(env))
    return env

PAR = {k: jasmin_params(k) for k in SETS}

# ---------------------------------------------------------------------------
# the role table: (name, EasyCrypt definition, Jasmin meaning, value). A
# definition that is a name of P (a base role) is written into the body as
# is; the others are operators of LayoutT.
# ---------------------------------------------------------------------------
ROLES = [
 # base roles: the specification parameters
 ("kvec",  "P.kvec", "MLKEM_K",  lambda p: p["MLKEM_K"]),
 ("du",    "P.du",   "MLKEM_DU", lambda p: p["MLKEM_DU"]),
 ("dv",    "P.dv",   "MLKEM_DV", lambda p: p["MLKEM_DV"]),
 ("eta1",  "P.eta1", "MLKEM_ETA1", lambda p: p["MLKEM_ETA1"]),
 # the operators of LayoutT
 ("vecn",          "256 * P.kvec",            "MLKEM_VECN",
                   lambda p: p["MLKEM_VECN"]),
 ("vecn_bytes",    "2 * vecn",                "bytes of a vector of u16 polynomials",
                   lambda p: 2 * p["MLKEM_VECN"]),
 ("matn",          "P.kvec * vecn",           "MLKEM_K * MLKEM_VECN",
                   lambda p: p["MLKEM_K"] * p["MLKEM_VECN"]),
 ("matn_bytes",    "2 * matn",                "bytes of a matrix of u16 polynomials",
                   lambda p: 2 * p["MLKEM_K"] * p["MLKEM_VECN"]),
 ("polyvec_bytes", "384 * P.kvec",            "MLKEM_POLYVECBYTES",
                   lambda p: p["MLKEM_POLYVECBYTES"]),
 ("pk_bytes",      "polyvec_bytes + 32",      "MLKEM_PUBLICKEYBYTES",
                   lambda p: p["MLKEM_PUBLICKEYBYTES"]),
 ("sk_bytes",      "2 * polyvec_bytes + 96",  "MLKEM_SECRETKEYBYTES",
                   lambda p: p["MLKEM_SECRETKEYBYTES"]),
 ("polyc_bytes",   "32 * P.dv",               "MLKEM_POLYCOMPRESSEDBYTES",
                   lambda p: p["MLKEM_POLYCOMPRESSEDBYTES"]),
 ("polyvecc_bytes", "P.kvec * (32 * P.du)",   "MLKEM_POLYVECCOMPRESSEDBYTES",
                   lambda p: p["MLKEM_POLYVECCOMPRESSEDBYTES"]),
 ("polyvecc_pad",  "polyvecc_bytes + 2 * (P.du - 10)",
                   "MLKEM_POLYVECCOMPRESSEDBYTES + MLKEM_POLYVECCOMPRESSEDPAD",
                   lambda p: p["MLKEM_POLYVECCOMPRESSEDBYTES"] + p["MLKEM_POLYVECCOMPRESSEDPAD"]),
 ("ct_bytes",      "polyvecc_bytes + polyc_bytes", "MLKEM_CIPHERTEXTBYTES",
                   lambda p: p["MLKEM_CIPHERTEXTBYTES"]),
 ("zct_bytes",     "32 + ct_bytes",           "MLKEM_SYMBYTES + MLKEM_CIPHERTEXTBYTES",
                   lambda p: p["MLKEM_SYMBYTES"] + p["MLKEM_CIPHERTEXTBYTES"]),
 ("idx_table",     "if P.kvec = 2 then 16 else 32 * (P.kvec - 2)", "IDX_TABLE_SIZE",
                   lambda p: 2 ** (p["MLKEM_K"] + 2)),
 ("eta1_bytes",    "64 * P.eta1 + 8 * (P.eta1 - 2)", "MLKEM_ETA1_BUFBYTES",
                   lambda p: p["MLKEM_ETA1_BUFBYTES"]),
]
ROLE = {r[0]: r for r in ROLES}

def is_base(name):
    return re.fullmatch(r"P\.\w+", ROLE[name][1]) is not None

def deps(ecdef):
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
def split_abbrevs(head):
    """The global constants of a model, as {name: text}, in order."""
    i = head.find("abbrev ")
    if i < 0: return {}
    out = {}
    for mo in re.finditer(r"abbrev (\w+) =(.*?)\.\n(?=\s*(?:abbrev |\Z))", head[i:] + "\n", re.S):
        out[mo.group(1)] = mo.group(0).rstrip("\n")
    return out

def sort_locals(body):
    """Sort the `var' declarations of every procedure by variable name."""
    def fix(mo):
        decls = re.findall(r"    var [^;]*;\n", mo.group(0))
        return "".join(sorted(decls, key=lambda d: d.split()[1].split(":")[0]))
    return re.sub(r"(?:    var [^;]*;\n)+", fix, body)

def read_model(k):
    txt = open(os.path.join(HERE, str(k), "Jkem_avx2.ec")).read()
    i = txt.index("module M = {")
    head, body = txt[:i], sort_locals(txt[i:])
    blank = re.sub(r"\(\*.*?\*\)", lambda mo: " " * len(mo.group(0)), body, flags=re.S)
    toks = [(mo.group(0), mo.start(), mo.end()) for mo in TOKRE.finditer(blank)]
    return head, body, toks

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

def write(path, s):
    open(path, "w").write(s)
    print("wrote %s (%d bytes)" % (os.path.relpath(path, HERE), len(s)))

GEN = "(* GENERATED by proofs/mlkem-correctness/extraction/avx2/generalize.py -- do not edit. *)\n"

def main():
    models = {k: read_model(k) for k in SETS}
    head, body, toks = models[SETS[0]]
    n = len(toks)
    for k in SETS:
        if len(models[k][2]) != n:
            sys.exit("token count mismatch: %d has %d tokens, %d has %d"
                     % (k, len(models[k][2]), SETS[0], n))

    # the constant tables: shared ones, and per-set ones (arrays sized by a role)
    tabs = {k: split_abbrevs(models[k][0]) for k in SETS}
    names = list(tabs[SETS[0]])
    for k in SETS:
        if list(tabs[k]) != names:
            sys.exit("the constant tables of %d and %d differ in names" % (k, SETS[0]))
    shared = [nm for nm in names if all(tabs[k][nm] == tabs[SETS[0]][nm] for k in SETS)]
    perset = [nm for nm in names if nm not in shared]
    const_hdr = set(re.findall(r"\bW?Array\d+\b", "".join(tabs[SETS[0]][nm] for nm in shared)))

    pvars = set(re.findall(r"\b([a-zA-Z_][A-Za-z_0-9']*)\s*:\s*(?:int|bool|W\d+\.t)", body))
    clash = sorted(r for r in ROLE if r in pvars and not is_base(r))
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

    # the per-set tables: typed by the array role of their size
    tables = []
    for nm in perset:
        sizes, elems = [], set()
        for k in SETS:
            mo = re.search(r"\(\((Array\d+)\.of_list witness\)", tabs[k][nm])
            if not mo:
                errors.append("per-set table %s is not an of_list array" % nm); break
            sizes.append(arrkey(mo.group(1))[1])
            elems |= set(re.findall(r"\((W\d+)\.of_int", tabs[k][nm]))
        else:
            role = ROLE_OF_TUPLE.get(tuple(sizes))
            if role is None or len(elems) != 1:
                errors.append("no role for the table %s %s" % (nm, sizes)); continue
            used.add(role)
            sym_arr[("Array", role)] = {k: "Array%d" % sizes[j] for j, k in enumerate(SETS)}
            tables.append((nm, elems.pop(), role))
    if errors:
        for m in errors[:40]: print("ERROR:", m, file=sys.stderr)
        sys.exit("%d unexplained leaves" % len(errors))

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

    os.makedirs(GEN_DIR, exist_ok=True)
    arrays = sorted(sym_arr, key=lambda x: (x[1], x[0]))
    emit_layout(needed, arrays)
    emit_constants([tabs[SETS[0]][nm] for nm in shared], const_hdr)
    emit_generic(generic_body, const_arr | const_hdr, arrays, tables)
    for k in SETS:
        emit_instance(k, sym_arr, arrays, tables)

    print("roles (%d):" % len(needed))
    for name, ecdef, jas, _ in ROLES:
        if name in needed:
            print("  %-15s = %-34s %s" % (name, ecdef, role_tuple(name)))
    print("symbolic array theories (%d); per-set tables: %s"
          % (len(arrays), [t[0] for t in tables]))
    if ALIASES: print("alias classes:", ALIASES)

def role_comment(needed):
    L = ["(* Vocabulary: every leaf of the models that varies with the\n",
         "   parameter set is one of these. Values for ML-KEM-768/1024, and\n",
         "   the Jasmin parameter each one stands for:\n"]
    for name, ecdef, jas, _ in ROLES:
        if name in needed:
            L.append("     %-15s %-14s %s\n" % (name, "%s" % (role_tuple(name),), jas))
    L.append("*)\n")
    return "".join(L)

def emit_layout(needed, arrays):
    L = [GEN, "require import AllCore IntDiv List.\n",
         "from Jasmin require import JArray JWord_array.\n",
         "from Spec require Parameters.\n\n",
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
    write(os.path.join(GEN_DIR, "LayoutT.ec"), "".join(L))

def emit_constants(abbrevs, const_hdr):
    L = [GEN,
         "(* The constant tables of the models {768,1024}/Jkem_avx2.ec that *)\n",
         "(* are the same for every parameter set.                         *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n\n"]
    if const_hdr:
        L.append("from JazzEC " + wrap_require(sorted(const_hdr, key=arrkey)))
    L.append("\n" + "\n\n".join(abbrevs) + "\n")
    write(os.path.join(GEN_DIR, "JkemConstants.ec"), "".join(L))

def emit_generic(body, const_arr, arrays, tables):
    L = [GEN,
         "(* The generic form of the models {768,1024}/Jkem_avx2.ec: one module *)\n",
         "(* M whose varying leaves are the operators of LayoutT. The instance  *)\n",
         "(* files realize it by each model.                                    *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n\nimport SLH64.\n\n"]
    if const_arr:
        L.append("from JazzEC " + wrap_require(sorted(const_arr, key=arrkey)))
    L.append("require import JkemConstants.\nrequire LayoutT.\n\n"
             "abstract theory JkemT.\n\nclone include LayoutT.LayoutT.\n\n")
    for kind, role in arrays:
        L.append("import %s_%s.\n" % (kind, role))
    if tables:
        L.append("\n(* the constant tables of the parameter set *)\n")
        for nm, elem, role in tables:
            L.append("op %s : %s.t Array_%s.t.\n" % (nm, elem, role))
    L.append("\n" + body + "\nend JkemT.\n")
    write(os.path.join(GEN_DIR, "JkemT.ec"), "".join(L))

def emit_instance(k, sym_arr, arrays, tables):
    arrs = sorted(set(sym_arr[a][k] for a in arrays), key=arrkey)
    L = [GEN,
         "(* ML-KEM-%d: the instance of JkemT whose module M is the model      *)\n" % k,
         "(* Jkem_avx2.M. EasyCrypt accepts `module M <= Jkem_avx2.M' only     *)\n",
         "(* when the generic body, at these parameters, is convertible to the *)\n",
         "(* extracted body.                                                   *)\n",
         "require import AllCore IntDiv CoreMap List Distr.\n",
         "from Jasmin require import JModel_x86.\n",
         "from JazzEC require import Jkem_avx2.\n",
         "from JazzEC " + wrap_require(arrs),
         "from Spec require Spec%d.\n" % k,
         "require JkemT.\n\n",
         "clone JkemT.JkemT as Jkem%dI with\n" % k]
    items = ["  theory P <= Spec%d.Params%d" % (k, k)]
    for kind, role in arrays:
        items.append("  theory %s_%s <= %s" % (kind, role, sym_arr[(kind, role)][k]))
    for nm, _, _ in tables:
        items.append("  op %s = Jkem_avx2.%s" % (nm, nm))
    items.append("  module M <= Jkem_avx2.M")
    L.append(",\n".join(items))
    L.append(".\n")
    write(os.path.join(INST_DIR, str(k), "Jkem%dI.ec" % k), "".join(L))

if __name__ == "__main__":
    main()
