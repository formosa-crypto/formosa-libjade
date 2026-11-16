require import AllCore IntDiv CoreMap List Distr.

from Jasmin require import JModel_x86.

import SLH64.

require import
BArray8 BArray16 BArray28 BArray32 BArray48 BArray64 BArray128 BArray256
BArray512 BArray640 BArray1280.

abbrev sHA512_256_IV =
(BArray64.of_list64
[(W64.of_int 2463787394917988140); (W64.of_int (-6965556091613846334));
(W64.of_int 2563595384472711505); (W64.of_int (-7622211418569250115));
(W64.of_int (-7626776825740460061)); (W64.of_int (-4729309413028513390));
(W64.of_int 3098927326965381290); (W64.of_int 1060366662362279074)]).

abbrev sHA512_224_IV =
(BArray64.of_list64
[(W64.of_int (-8341449602262348382)); (W64.of_int 8350123849800275158);
(W64.of_int 2160240930085379202); (W64.of_int 7466358040605728719);
(W64.of_int 1111592415079452072); (W64.of_int 8638871050018654530);
(W64.of_int 4583966954114332360); (W64.of_int 1230299281376055969)]).

abbrev sHA384_IV =
(BArray64.of_list64
[(W64.of_int (-3766243637369397544)); (W64.of_int 7105036623409894663);
(W64.of_int (-7973340178411365097)); (W64.of_int 1526699215303891257);
(W64.of_int 7436329637833083697); (W64.of_int (-8163818279084223215));
(W64.of_int (-2662702644619276377)); (W64.of_int 5167115440072839076)]).

abbrev sHA512_IV =
(BArray64.of_list64
[(W64.of_int 7640891576956012808); (W64.of_int (-4942790177534073029));
(W64.of_int 4354685564936845355); (W64.of_int (-6534734903238641935));
(W64.of_int 5840696475078001361); (W64.of_int (-7276294671716946913));
(W64.of_int 2270897969802886507); (W64.of_int 6620516959819538809)]).

abbrev sHA512_AVX2_BSWAP =
(BArray32.of_list64
[(W64.of_int 283686952306183); (W64.of_int 579005069656919567);
(W64.of_int 283686952306183); (W64.of_int 579005069656919567)]).

abbrev sHA512_K =
(BArray640.of_list64
[(W64.of_int 4794697086780616226); (W64.of_int 8158064640168781261);
(W64.of_int (-5349999486874862801)); (W64.of_int (-1606136188198331460));
(W64.of_int 4131703408338449720); (W64.of_int 6480981068601479193);
(W64.of_int (-7908458776815382629)); (W64.of_int (-6116909921290321640));
(W64.of_int (-2880145864133508542)); (W64.of_int 1334009975649890238);
(W64.of_int 2608012711638119052); (W64.of_int 6128411473006802146);
(W64.of_int 8268148722764581231); (W64.of_int (-9160688886553864527));
(W64.of_int (-7215885187991268811)); (W64.of_int (-4495734319001033068));
(W64.of_int (-1973867731355612462)); (W64.of_int (-1171420211273849373));
(W64.of_int 1135362057144423861); (W64.of_int 2597628984639134821);
(W64.of_int 3308224258029322869); (W64.of_int 5365058923640841347);
(W64.of_int 6679025012923562964); (W64.of_int 8573033837759648693);
(W64.of_int (-7476448914759557205)); (W64.of_int (-6327057829258317296));
(W64.of_int (-5763719355590565569)); (W64.of_int (-4658551843659510044));
(W64.of_int (-4116276920077217854)); (W64.of_int (-3051310485924567259));
(W64.of_int 489312712824947311); (W64.of_int 1452737877330783856);
(W64.of_int 2861767655752347644); (W64.of_int 3322285676063803686);
(W64.of_int 5560940570517711597); (W64.of_int 5996557281743188959);
(W64.of_int 7280758554555802590); (W64.of_int 8532644243296465576);
(W64.of_int (-9096487096722542874)); (W64.of_int (-7894198246740708037));
(W64.of_int (-6719396339535248540)); (W64.of_int (-6333637450476146687));
(W64.of_int (-4446306890439682159)); (W64.of_int (-4076793802049405392));
(W64.of_int (-3345356375505022440)); (W64.of_int (-2983346525034927856));
(W64.of_int (-860691631967231958)); (W64.of_int 1182934255886127544);
(W64.of_int 1847814050463011016); (W64.of_int 2177327727835720531);
(W64.of_int 2830643537854262169); (W64.of_int 3796741975233480872);
(W64.of_int 4115178125766777443); (W64.of_int 5681478168544905931);
(W64.of_int 6601373596472566643); (W64.of_int 7507060721942968483);
(W64.of_int 8399075790359081724); (W64.of_int 8693463985226723168);
(W64.of_int (-8878714635349349518)); (W64.of_int (-8302665154208450068));
(W64.of_int (-8016688836872298968)); (W64.of_int (-6606660893046293015));
(W64.of_int (-4685533653050689259)); (W64.of_int (-4147400797238176981));
(W64.of_int (-3880063495543823972)); (W64.of_int (-3348786107499101689));
(W64.of_int (-1523767162380948706)); (W64.of_int (-757361751448694408));
(W64.of_int 500013540394364858); (W64.of_int 748580250866718886);
(W64.of_int 1242879168328830382); (W64.of_int 1977374033974150939);
(W64.of_int 2944078676154940804); (W64.of_int 3659926193048069267);
(W64.of_int 4368137639120453308); (W64.of_int 4836135668995329356);
(W64.of_int 5532061633213252278); (W64.of_int 6448918945643986474);
(W64.of_int 6902733635092675308); (W64.of_int 7801388544844847127)]).

abbrev sHA224_IV =
(BArray32.of_list32
[(W32.of_int (-1056596264)); (W32.of_int 914150663); (W32.of_int 812702999);
(W32.of_int (-150054599)); (W32.of_int (-4191439)); (W32.of_int 1750603025);
(W32.of_int 1694076839); (W32.of_int (-1090891868))]).

abbrev sHA256_IV =
(BArray32.of_list32
[(W32.of_int 1779033703); (W32.of_int (-1150833019));
(W32.of_int 1013904242); (W32.of_int (-1521486534)); (W32.of_int 1359893119);
(W32.of_int (-1694144372)); (W32.of_int 528734635); (W32.of_int 1541459225)]).

abbrev sHA256_AVX2_HI =
(BArray32.of_list32
[(W32.of_int (-1)); (W32.of_int (-1)); (W32.of_int 50462976);
(W32.of_int 185207048); (W32.of_int (-1)); (W32.of_int (-1));
(W32.of_int 50462976); (W32.of_int 185207048)]).

abbrev sHA256_AVX2_LO =
(BArray32.of_list32
[(W32.of_int 50462976); (W32.of_int 185207048); (W32.of_int (-1));
(W32.of_int (-1)); (W32.of_int 50462976); (W32.of_int 185207048);
(W32.of_int (-1)); (W32.of_int (-1))]).

abbrev sHA256_AVX2_BSWAP =
(BArray32.of_list32
[(W32.of_int 66051); (W32.of_int 67438087); (W32.of_int 134810123);
(W32.of_int 202182159); (W32.of_int 66051); (W32.of_int 67438087);
(W32.of_int 134810123); (W32.of_int 202182159)]).

abbrev sHA256_K =
(BArray256.of_list32
[(W32.of_int 1116352408); (W32.of_int 1899447441);
(W32.of_int (-1245643825)); (W32.of_int (-373957723));
(W32.of_int 961987163); (W32.of_int 1508970993); (W32.of_int (-1841331548));
(W32.of_int (-1424204075)); (W32.of_int (-670586216));
(W32.of_int 310598401); (W32.of_int 607225278); (W32.of_int 1426881987);
(W32.of_int 1925078388); (W32.of_int (-2132889090));
(W32.of_int (-1680079193)); (W32.of_int (-1046744716));
(W32.of_int (-459576895)); (W32.of_int (-272742522)); (W32.of_int 264347078);
(W32.of_int 604807628); (W32.of_int 770255983); (W32.of_int 1249150122);
(W32.of_int 1555081692); (W32.of_int 1996064986); (W32.of_int (-1740746414));
(W32.of_int (-1473132947)); (W32.of_int (-1341970488));
(W32.of_int (-1084653625)); (W32.of_int (-958395405));
(W32.of_int (-710438585)); (W32.of_int 113926993); (W32.of_int 338241895);
(W32.of_int 666307205); (W32.of_int 773529912); (W32.of_int 1294757372);
(W32.of_int 1396182291); (W32.of_int 1695183700); (W32.of_int 1986661051);
(W32.of_int (-2117940946)); (W32.of_int (-1838011259));
(W32.of_int (-1564481375)); (W32.of_int (-1474664885));
(W32.of_int (-1035236496)); (W32.of_int (-949202525));
(W32.of_int (-778901479)); (W32.of_int (-694614492));
(W32.of_int (-200395387)); (W32.of_int 275423344); (W32.of_int 430227734);
(W32.of_int 506948616); (W32.of_int 659060556); (W32.of_int 883997877);
(W32.of_int 958139571); (W32.of_int 1322822218); (W32.of_int 1537002063);
(W32.of_int 1747873779); (W32.of_int 1955562222); (W32.of_int 2024104815);
(W32.of_int (-2067236844)); (W32.of_int (-1933114872));
(W32.of_int (-1866530822)); (W32.of_int (-1538233109));
(W32.of_int (-1090935817)); (W32.of_int (-965641998))]).

module M = {
  proc __bswap32 (x:W32.t) : W32.t = {
    
    x <- (BSWAP_32 x);
    return x;
  }
  proc __bswap64 (x:W64.t) : W64.t = {
    
    x <- (BSWAP_64 x);
    return x;
  }
  proc __fill64_mem (buf:BArray64.t, dst_:W64.t, p_:W64.t, n_:W64.t, ms:W64.t) : 
  BArray64.t * W64.t = {
    var dst:W64.t;
    var p:W64.t;
    var n:W64.t;
    var head:W64.t;
    var end_0:W64.t;
    var more:bool;
    var t:W64.t;
    dst <- dst_;
    p <- p_;
    n <- n_;
    head <- dst;
    head <- (- head);
    head <- (head `&` (W64.of_int 7));
    head <- ((n \ult head) ? n : head);
    n <- (n - head);
    end_0 <- dst;
    end_0 <- (end_0 + head);
    more <- (dst \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      buf <- (BArray64.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    more <- ((W64.of_int 8) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      t <- (loadW64 Glob.mem (W64.to_uint p));
      buf <- (BArray64.set64d buf (W64.to_uint dst) t);
      dst <- (dst + (W64.of_int 8));
      p <- (p + (W64.of_int 8));
      n <- (n - (W64.of_int 8));
      more <- ((W64.of_int 8) \ule n);
    }
    ms <- (update_msf (! more) ms);
    end_0 <- dst;
    end_0 <- (end_0 + n);
    more <- (dst \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      buf <- (BArray64.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    return (buf, ms);
  }
  proc __fill128_mem (buf:BArray128.t, dst_:W64.t, p_:W64.t, n_:W64.t,
                      ms:W64.t) : BArray128.t * W64.t = {
    var dst:W64.t;
    var p:W64.t;
    var n:W64.t;
    var head:W64.t;
    var end_0:W64.t;
    var more:bool;
    var t:W64.t;
    dst <- dst_;
    p <- p_;
    n <- n_;
    head <- dst;
    head <- (- head);
    head <- (head `&` (W64.of_int 7));
    head <- ((n \ult head) ? n : head);
    n <- (n - head);
    end_0 <- dst;
    end_0 <- (end_0 + head);
    more <- (dst \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      buf <- (BArray128.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    more <- ((W64.of_int 8) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      t <- (loadW64 Glob.mem (W64.to_uint p));
      buf <- (BArray128.set64d buf (W64.to_uint dst) t);
      dst <- (dst + (W64.of_int 8));
      p <- (p + (W64.of_int 8));
      n <- (n - (W64.of_int 8));
      more <- ((W64.of_int 8) \ule n);
    }
    ms <- (update_msf (! more) ms);
    end_0 <- dst;
    end_0 <- (end_0 + n);
    more <- (dst \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      buf <- (BArray128.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    return (buf, ms);
  }
  proc __zero64 (buf:BArray64.t, lo_:W64.t, hi:W64.t, ms:W64.t) : BArray64.t *
                                                                  W64.t = {
    var lo:W64.t;
    var z:W64.t;
    var end_0:W64.t;
    var more:bool;
    lo <- lo_;
    z <- (W64.of_int 0);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 7));
    end_0 <- (end_0 `&` (W64.of_int (- 8)));
    end_0 <- ((hi \ult end_0) ? hi : end_0);
    more <- (lo \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray64.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 8));
    more <- (end_0 \ule hi);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray64.set64d buf (W64.to_uint lo) z);
      lo <- (lo + (W64.of_int 8));
      end_0 <- lo;
      end_0 <- (end_0 + (W64.of_int 8));
      more <- (end_0 \ule hi);
    }
    ms <- (update_msf (! more) ms);
    more <- (lo \ult hi);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray64.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult hi);
    }
    ms <- (update_msf (! more) ms);
    return (buf, ms);
  }
  proc __zero128 (buf:BArray128.t, lo_:W64.t, hi:W64.t, ms:W64.t) : BArray128.t *
                                                                    W64.t = {
    var lo:W64.t;
    var z:W64.t;
    var end_0:W64.t;
    var more:bool;
    lo <- lo_;
    z <- (W64.of_int 0);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 7));
    end_0 <- (end_0 `&` (W64.of_int (- 8)));
    end_0 <- ((hi \ult end_0) ? hi : end_0);
    more <- (lo \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray128.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 8));
    more <- (end_0 \ule hi);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray128.set64d buf (W64.to_uint lo) z);
      lo <- (lo + (W64.of_int 8));
      end_0 <- lo;
      end_0 <- (end_0 + (W64.of_int 8));
      more <- (end_0 \ule hi);
    }
    ms <- (update_msf (! more) ms);
    more <- (lo \ult hi);
    while (more) {
      ms <- (update_msf more ms);
      buf <- (BArray128.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult hi);
    }
    ms <- (update_msf (! more) ms);
    return (buf, ms);
  }
  proc __sha256_avx2_round (v:BArray32.t, m:BArray8.t, s:W32.t, t:int,
                            x:BArray128.t, lo:W256.t, hi:W256.t, j:int,
                            ph:int) : BArray32.t * BArray8.t * W32.t *
                                      BArray128.t = {
    var vs:W256.t;
    var vw:W256.t;
    var y:W32.t;
    var vt:W256.t;
    var vu:W256.t;
    var z:W32.t;
    var w:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    if ((ph = 0)) {
      vs <-
      (VPALIGNR_256 (BArray128.get256 x ((j + 1) %% 4))
      (BArray128.get256 x (j %% 4)) (W8.of_int 4));
      vw <-
      (VPALIGNR_256 (BArray128.get256 x ((j + 3) %% 4))
      (BArray128.get256 x ((j + 2) %% 4)) (W8.of_int 4));
    } else {
      
    }
    if ((ph = 1)) {
      vs <-
      (VPSHUFD_256 (BArray128.get256 x ((j + 3) %% 4)) (W8.of_int 250));
    } else {
      
    }
    if ((ph = 2)) {
      vs <- (VPSHUFD_256 (BArray128.get256 x (j %% 4)) (W8.of_int 80));
    } else {
      
    }
    v <-
    (BArray32.set32 v (((0 + 64) - t) %% 8)
    ((BArray32.get32 v (((0 + 64) - t) %% 8)) + s));
    y <- (BArray32.get32 v (((5 + 64) - t) %% 8));
    y <- (y `&` (BArray32.get32 v (((4 + 64) - t) %% 8)));
    if ((ph = 0)) {
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vw));
      vt <- (vs \vshr32u256 (W128.of_int 7));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      vu <- (vs \vshr32u256 (W128.of_int 10));
      vs <- (vs \vshr64u256 (W128.of_int 17));
    } else {
      
    }
    z <- (RORX_32 (BArray32.get32 v (((4 + 64) - t) %% 8)) (W8.of_int 25));
    w <- (RORX_32 (BArray32.get32 v (((4 + 64) - t) %% 8)) (W8.of_int 11));
    v <-
    (BArray32.set32 v (((7 + 64) - t) %% 8)
    ((BArray32.get32 v (((7 + 64) - t) %% 8)) + y));
    if ((ph = 0)) {
      vu <- (vs \vshr32u256 (W128.of_int 3));
      vw <- (vs \vshl32u256 (W128.of_int 14));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      vu <- (vu `^` vs);
      vs <- (vs \vshr64u256 (W128.of_int 2));
    } else {
      
    }
    ( _0,  _1,  _2,  _3,  _4, y) <-
    (ANDN_32 (BArray32.get32 v (((4 + 64) - t) %% 8))
    (BArray32.get32 v (((6 + 64) - t) %% 8)));
    z <- (z `^` w);
    w <- (RORX_32 (BArray32.get32 v (((4 + 64) - t) %% 8)) (W8.of_int 6));
    if ((ph = 0)) {
      vu <- (vu `^` vt);
      vt <- (vt \vshr32u256 (W128.of_int 11));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      vu <- (vu `^` vs);
    } else {
      
    }
    v <-
    (BArray32.set32 v (((7 + 64) - t) %% 8)
    ((BArray32.get32 v (((7 + 64) - t) %% 8)) + y));
    z <- (z `^` w);
    m <-
    (BArray8.set32 m ((t + 1) %% 2) (BArray32.get32 v (((0 + 64) - t) %% 8)));
    y <- (RORX_32 (BArray32.get32 v (((0 + 64) - t) %% 8)) (W8.of_int 22));
    if ((ph = 0)) {
      vu <- (vu `^` vw);
      vw <- (vw \vshl32u256 (W128.of_int 11));
    } else {
      
    }
    if ((ph = 1)) {
      vu <- (VPSHUFB_256 vu lo);
    } else {
      
    }
    if ((ph = 2)) {
      vu <- (VPSHUFB_256 vu hi);
    } else {
      
    }
    v <-
    (BArray32.set32 v (((7 + 64) - t) %% 8)
    ((BArray32.get32 v (((7 + 64) - t) %% 8)) + z));
    m <-
    (BArray8.set32 m ((t + 1) %% 2)
    ((BArray8.get32 m ((t + 1) %% 2)) `^`
    (BArray32.get32 v (((1 + 64) - t) %% 8))));
    s <- (RORX_32 (BArray32.get32 v (((0 + 64) - t) %% 8)) (W8.of_int 13));
    if ((ph = 0)) {
      vu <- (vu `^` vt);
      vu <- (vu `^` vw);
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vu));
    } else {
      
    }
    z <- (RORX_32 (BArray32.get32 v (((0 + 64) - t) %% 8)) (W8.of_int 2));
    v <-
    (BArray32.set32 v (((3 + 64) - t) %% 8)
    ((BArray32.get32 v (((3 + 64) - t) %% 8)) +
    (BArray32.get32 v (((7 + 64) - t) %% 8))));
    m <-
    (BArray8.set32 m (t %% 2)
    ((BArray8.get32 m (t %% 2)) `&` (BArray8.get32 m ((t + 1) %% 2))));
    s <- (s `^` y);
    if ((ph = 0)) {
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vu));
    } else {
      
    }
    m <-
    (BArray8.set32 m (t %% 2)
    ((BArray8.get32 m (t %% 2)) `^` (BArray32.get32 v (((1 + 64) - t) %% 8)))
    );
    s <- (s `^` z);
    v <-
    (BArray32.set32 v (((7 + 64) - t) %% 8)
    ((BArray32.get32 v (((7 + 64) - t) %% 8)) + (BArray8.get32 m (t %% 2))));
    return (v, m, s, x);
  }
  proc __sha256_avx2 (h:BArray32.t, x:BArray128.t, nb:int, ms:W64.t) : 
  BArray32.t * W64.t = {
    var inc:int;
    var i:int;
    var k:W256.t;
    var wk:BArray512.t;
    var lo_p:BArray32.t;
    var lo:W256.t;
    var hi_p:BArray32.t;
    var hi:W256.t;
    var v:BArray32.t;
    var m:BArray8.t;
    var s:W32.t;
    var t:int;
    var l:int;
    hi_p <- witness;
    lo_p <- witness;
    m <- witness;
    v <- witness;
    wk <- witness;
    i <- 0;
    while ((i < 4)) {
      k <- (VPBROADCAST_2u128 (BArray256.get128 sHA256_K i));
      k <- (k \vadd32u256 (BArray128.get256 x i));
      wk <- (BArray512.set256 wk i k);
      i <- (i + 1);
    }
    lo_p <- sHA256_AVX2_LO;
    lo <- (BArray32.get256 lo_p 0);
    hi_p <- sHA256_AVX2_HI;
    hi <- (BArray32.get256 hi_p 0);
    i <- 0;
    while ((i < 8)) {
      v <- (BArray32.set32 v i (BArray32.get32 h i));
      i <- (i + 1);
    }
    inc <- nb;
    l <- 0;
    while ((l < inc)) {
      (* Erased call to spill *)
      m <- (BArray8.set32 m 0 (BArray32.get32 v 1));
      m <-
      (BArray8.set32 m 0 ((BArray8.get32 m 0) `^` (BArray32.get32 v 2)));
      s <- (W32.of_int 0);
      t <- 0;
      while ((t < 64)) {
        v <-
        (BArray32.set32 v (((7 + 64) - t) %% 8)
        ((BArray32.get32 v (((7 + 64) - t) %% 8)) +
        (BArray512.get32 wk (((8 * (t %/ 4)) + (4 * l)) + (t %% 4)))));
        if (((l = 0) /\ (t < 48))) {
          (v, m, s, x) <@ __sha256_avx2_round (v, m, s, t, x, lo, hi,
          (t %/ 4), (t %% 4));
        } else {
          (v, m, s, x) <@ __sha256_avx2_round (v, m, s, t, x, lo, hi, 0, 3);
        }
        if ((((l = 0) /\ (t < 48)) /\ ((t %% 4) = 2))) {
          k <-
          (VPBROADCAST_2u128 (BArray256.get128 sHA256_K (4 + (t %/ 4))));
          k <- (k \vadd32u256 (BArray128.get256 x ((t %/ 4) %% 4)));
          wk <- (BArray512.set256 wk (4 + (t %/ 4)) k);
        } else {
          
        }
        t <- (t + 1);
      }
      v <- (BArray32.set32 v 0 ((BArray32.get32 v 0) + s));
      (* Erased call to unspill *)
      h <- (protect_ptr h ms);
      i <- 0;
      while ((i < 8)) {
        v <-
        (BArray32.set32 v i ((BArray32.get32 v i) + (BArray32.get32 h i)));
        h <- (BArray32.set32 h i (BArray32.get32 v i));
        i <- (i + 1);
      }
      l <- (l + 1);
    }
    return (h, ms);
  }
  proc _sha256_compress (h:BArray32.t, block:BArray64.t, ms:W64.t) : 
  BArray32.t * W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      x <-
      (BArray128.set256 x i (VPBROADCAST_2u128 (BArray64.get128 block i)));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha256_avx2 (h, x, 1, ms);
    return (h, ms);
  }
  proc _sha256_compress_one (h:BArray32.t, p:W64.t, ms:W64.t) : BArray32.t *
                                                                W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      x <-
      (BArray128.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha256_avx2 (h, x, 1, ms);
    return (h, ms);
  }
  proc _sha256_compress_two (h:BArray32.t, p:W64.t, ms:W64.t) : BArray32.t *
                                                                W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      x <-
      (BArray128.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      x <-
      (BArray128.set256 x i
      (VINSERTI128 (BArray128.get256 x i)
      (loadW128 Glob.mem
      (W64.to_uint ((p + (W64.of_int 64)) + (W64.of_int (16 * i)))))
      (W8.of_int 1)));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha256_avx2 (h, x, 2, ms);
    return (h, ms);
  }
  proc _sha256_compress_blocks (h:BArray32.t, p:W64.t, n:W64.t, ms:W64.t) : 
  BArray32.t * W64.t = {
    var more:bool;
    more <- ((W64.of_int 2) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha256_compress_two (h, p, ms);
      (* Erased call to unspill *)
      p <- (protect_64 p ms);
      n <- (protect_64 n ms);
      p <- (p + (W64.of_int 128));
      n <- (n - (W64.of_int 2));
      more <- ((W64.of_int 2) \ule n);
    }
    ms <- (update_msf (! more) ms);
    more <- (n <> (W64.of_int 0));
    if (more) {
      ms <- (update_msf more ms);
      (h, ms) <@ _sha256_compress_one (h, p, ms);
    } else {
      ms <- (update_msf (! more) ms);
    }
    return (h, ms);
  }
  proc __sha256_init (h:BArray32.t) : BArray32.t = {
    var iv:BArray32.t;
    var i:int;
    var t:W32.t;
    iv <- witness;
    iv <- sHA256_IV;
    i <- 0;
    while ((i < 8)) {
      t <- (BArray32.get32 iv i);
      h <- (BArray32.set32 h i t);
      i <- (i + 1);
    }
    return h;
  }
  proc __sha224_init (h:BArray32.t) : BArray32.t = {
    var iv:BArray32.t;
    var i:int;
    var t:W32.t;
    iv <- witness;
    iv <- sHA224_IV;
    i <- 0;
    while ((i < 8)) {
      t <- (BArray32.get32 iv i);
      h <- (BArray32.set32 h i t);
      i <- (i + 1);
    }
    return h;
  }
  proc _sha256_absorb_mem (h:BArray32.t, buf:BArray64.t, total:W64.t,
                           in_0:W64.t, inlen:W64.t, ms:W64.t) : BArray32.t *
                                                                BArray64.t *
                                                                W64.t * W64.t = {
    var fill:W64.t;
    var n:W64.t;
    var full:bool;
    var off:W64.t;
    var more:bool;
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    total <- (total + inlen);
    n <- (W64.of_int 64);
    n <- (n - fill);
    n <- ((inlen \ult n) ? inlen : n);
    n <- ((fill = (W64.of_int 0)) ? fill : n);
    inlen <- (inlen - n);
    (buf, ms) <@ __fill64_mem (buf, fill, in_0, n, ms);
    fill <- (fill + n);
    in_0 <- (in_0 + n);
    full <- (fill = (W64.of_int 64));
    if (full) {
      ms <- (update_msf full ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha256_compress (h, buf, ms);
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      buf <- (protect_ptr buf ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! full) ms);
    }
    off <- (W64.of_int 0);
    n <- inlen;
    n <- (n `>>` (W8.of_int 6));
    more <- (n <> (W64.of_int 0));
    if (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha256_compress_blocks (h, in_0, n, ms);
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      buf <- (protect_ptr buf ms);
      off <- inlen;
      off <- (off `>>` (W8.of_int 6));
      off <- (off `<<` (W8.of_int 6));
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! more) ms);
    }
    inlen <- (inlen - off);
    in_0 <- (in_0 + off);
    (buf, ms) <@ __fill64_mem (buf, fill, in_0, inlen, ms);
    return (h, buf, total, ms);
  }
  proc _sha256___sha256_finalize (out:BArray32.t, h:BArray32.t,
                                  buf:BArray64.t, total:W64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * BArray64.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    t <- (W64.of_int 128);
    buf <- (BArray64.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 56) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 64);
      (buf, ms) <@ __zero64 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha256_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 56);
    (buf, ms) <@ __zero64 (buf, fill, hi, ms);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray64.set64d buf 56 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha256_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (32 %/ 4);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray32.get32 h i);
      x <@ __bswap32 (x);
      out <- (BArray32.set32 out i x);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha256____sha256_mem_from (out:BArray32.t, h:BArray32.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray32.t *
                                                            W64.t = {
    var buf_s:BArray64.t;
    var buf:BArray64.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha256_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha256___sha256_finalize (out, h, buf, total, ms);
    return (out, ms);
  }
  proc _sha224___sha256_finalize (out:BArray28.t, h:BArray32.t,
                                  buf:BArray64.t, total:W64.t, ms:W64.t) : 
  BArray28.t * BArray32.t * BArray64.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    t <- (W64.of_int 128);
    buf <- (BArray64.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 56) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 64);
      (buf, ms) <@ __zero64 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha256_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 56);
    (buf, ms) <@ __zero64 (buf, fill, hi, ms);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray64.set64d buf 56 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha256_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (28 %/ 4);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray32.get32 h i);
      x <@ __bswap32 (x);
      out <- (BArray28.set32 out i x);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha224____sha256_mem_from (out:BArray28.t, h:BArray32.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray28.t *
                                                            W64.t = {
    var buf_s:BArray64.t;
    var buf:BArray64.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha256_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha224___sha256_finalize (out, h, buf, total, ms);
    return (out, ms);
  }
  proc _sha256_mem (out:BArray32.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray32.t * W64.t = {
    var h:BArray32.t;
    h <- witness;
    h <@ __sha256_init (h);
    (out, ms) <@ _sha256____sha256_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc _sha224_mem (out:BArray28.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray28.t * W64.t = {
    var h:BArray32.t;
    h <- witness;
    h <@ __sha224_init (h);
    (out, ms) <@ _sha224____sha256_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc jade_hash_sha256_amd64_avx2 (out:BArray32.t, in_0:W64.t, inlen:W64.t) : 
  BArray32.t = {
    var ms:W64.t;
    ms <- (init_msf);
    (out, ms) <@ _sha256_mem (out, in_0, inlen, ms);
    return out;
  }
  proc __sha512_avx2_round (v:BArray64.t, m:BArray16.t, s:W64.t, t:int,
                            x:BArray256.t, j:int, ph:int) : BArray64.t *
                                                            BArray16.t *
                                                            W64.t *
                                                            BArray256.t = {
    var vs:W256.t;
    var vw:W256.t;
    var vu:W256.t;
    var y:W64.t;
    var vt:W256.t;
    var z:W64.t;
    var w:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    if ((ph = 0)) {
      vs <-
      (VPALIGNR_256 (BArray256.get256 x ((j + 1) %% 8))
      (BArray256.get256 x (j %% 8)) (W8.of_int 8));
      vw <-
      (VPALIGNR_256 (BArray256.get256 x ((j + 5) %% 8))
      (BArray256.get256 x ((j + 4) %% 8)) (W8.of_int 8));
    } else {
      
    }
    if ((ph = 1)) {
      vu <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshr64u256 (W128.of_int 6));
      vw <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshl64u256 (W128.of_int 3));
    } else {
      
    }
    v <-
    (BArray64.set64 v (((0 + 80) - t) %% 8)
    ((BArray64.get64 v (((0 + 80) - t) %% 8)) + s));
    y <- (BArray64.get64 v (((5 + 80) - t) %% 8));
    y <- (y `&` (BArray64.get64 v (((4 + 80) - t) %% 8)));
    if ((ph = 0)) {
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vw));
      vt <- (vs \vshr64u256 (W128.of_int 1));
    } else {
      
    }
    if ((ph = 1)) {
      vt <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshr64u256 (W128.of_int 19));
      vu <- (vu `^` vw);
    } else {
      
    }
    z <- (RORX_64 (BArray64.get64 v (((4 + 80) - t) %% 8)) (W8.of_int 41));
    w <- (RORX_64 (BArray64.get64 v (((4 + 80) - t) %% 8)) (W8.of_int 18));
    v <-
    (BArray64.set64 v (((7 + 80) - t) %% 8)
    ((BArray64.get64 v (((7 + 80) - t) %% 8)) + y));
    if ((ph = 0)) {
      vu <- (vs \vshr64u256 (W128.of_int 7));
      vw <- (vs \vshl64u256 (W128.of_int 56));
    } else {
      
    }
    if ((ph = 1)) {
      vw <- (vw \vshl64u256 (W128.of_int 42));
      vu <- (vu `^` vt);
    } else {
      
    }
    ( _0,  _1,  _2,  _3,  _4, y) <-
    (ANDN_64 (BArray64.get64 v (((4 + 80) - t) %% 8))
    (BArray64.get64 v (((6 + 80) - t) %% 8)));
    z <- (z `^` w);
    w <- (RORX_64 (BArray64.get64 v (((4 + 80) - t) %% 8)) (W8.of_int 14));
    if ((ph = 0)) {
      vu <- (vu `^` vt);
      vt <- (vt \vshr64u256 (W128.of_int 7));
    } else {
      
    }
    if ((ph = 1)) {
      vt <- (vt \vshr64u256 (W128.of_int 42));
      vu <- (vu `^` vw);
    } else {
      
    }
    v <-
    (BArray64.set64 v (((7 + 80) - t) %% 8)
    ((BArray64.get64 v (((7 + 80) - t) %% 8)) + y));
    z <- (z `^` w);
    m <-
    (BArray16.set64 m ((t + 1) %% 2) (BArray64.get64 v (((0 + 80) - t) %% 8))
    );
    y <- (RORX_64 (BArray64.get64 v (((0 + 80) - t) %% 8)) (W8.of_int 39));
    if ((ph = 0)) {
      vu <- (vu `^` vw);
      vw <- (vw \vshl64u256 (W128.of_int 7));
    } else {
      
    }
    if ((ph = 1)) {
      vu <- (vu `^` vt);
    } else {
      
    }
    v <-
    (BArray64.set64 v (((7 + 80) - t) %% 8)
    ((BArray64.get64 v (((7 + 80) - t) %% 8)) + z));
    m <-
    (BArray16.set64 m ((t + 1) %% 2)
    ((BArray16.get64 m ((t + 1) %% 2)) `^`
    (BArray64.get64 v (((1 + 80) - t) %% 8))));
    s <- (RORX_64 (BArray64.get64 v (((0 + 80) - t) %% 8)) (W8.of_int 34));
    if ((ph = 0)) {
      vu <- (vu `^` vt);
      vu <- (vu `^` vw);
    } else {
      
    }
    if ((ph = 1)) {
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vu));
    } else {
      
    }
    z <- (RORX_64 (BArray64.get64 v (((0 + 80) - t) %% 8)) (W8.of_int 28));
    v <-
    (BArray64.set64 v (((3 + 80) - t) %% 8)
    ((BArray64.get64 v (((3 + 80) - t) %% 8)) +
    (BArray64.get64 v (((7 + 80) - t) %% 8))));
    m <-
    (BArray16.set64 m (t %% 2)
    ((BArray16.get64 m (t %% 2)) `&` (BArray16.get64 m ((t + 1) %% 2))));
    s <- (s `^` y);
    if ((ph = 0)) {
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vu));
    } else {
      
    }
    m <-
    (BArray16.set64 m (t %% 2)
    ((BArray16.get64 m (t %% 2)) `^`
    (BArray64.get64 v (((1 + 80) - t) %% 8))));
    s <- (s `^` z);
    v <-
    (BArray64.set64 v (((7 + 80) - t) %% 8)
    ((BArray64.get64 v (((7 + 80) - t) %% 8)) + (BArray16.get64 m (t %% 2))));
    return (v, m, s, x);
  }
  proc __sha512_avx2 (h:BArray64.t, x:BArray256.t, nb:int, ms:W64.t) : 
  BArray64.t * W64.t = {
    var inc:int;
    var i:int;
    var k:W256.t;
    var wk:BArray1280.t;
    var v:BArray64.t;
    var m:BArray16.t;
    var s:W64.t;
    var t:int;
    var l:int;
    m <- witness;
    v <- witness;
    wk <- witness;
    i <- 0;
    while ((i < 8)) {
      k <- (VPBROADCAST_2u128 (BArray640.get128 sHA512_K i));
      k <- (k \vadd64u256 (BArray256.get256 x i));
      wk <- (BArray1280.set256 wk i k);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 8)) {
      v <- (BArray64.set64 v i (BArray64.get64 h i));
      i <- (i + 1);
    }
    inc <- nb;
    l <- 0;
    while ((l < inc)) {
      (* Erased call to spill *)
      m <- (BArray16.set64 m 0 (BArray64.get64 v 1));
      m <-
      (BArray16.set64 m 0 ((BArray16.get64 m 0) `^` (BArray64.get64 v 2)));
      s <- (W64.of_int 0);
      t <- 0;
      while ((t < 80)) {
        v <-
        (BArray64.set64 v (((7 + 80) - t) %% 8)
        ((BArray64.get64 v (((7 + 80) - t) %% 8)) +
        (BArray1280.get64 wk (((4 * (t %/ 2)) + (2 * l)) + (t %% 2)))));
        if (((l = 0) /\ (t < 64))) {
          (v, m, s, x) <@ __sha512_avx2_round (v, m, s, t, x, (t %/ 2),
          (t %% 2));
        } else {
          (v, m, s, x) <@ __sha512_avx2_round (v, m, s, t, x, 0, 2);
        }
        if ((((l = 0) /\ (t < 64)) /\ ((t %% 2) = 1))) {
          k <-
          (VPBROADCAST_2u128 (BArray640.get128 sHA512_K (8 + (t %/ 2))));
          k <- (k \vadd64u256 (BArray256.get256 x ((t %/ 2) %% 8)));
          wk <- (BArray1280.set256 wk (8 + (t %/ 2)) k);
        } else {
          
        }
        t <- (t + 1);
      }
      v <- (BArray64.set64 v 0 ((BArray64.get64 v 0) + s));
      (* Erased call to unspill *)
      h <- (protect_ptr h ms);
      i <- 0;
      while ((i < 8)) {
        v <-
        (BArray64.set64 v i ((BArray64.get64 v i) + (BArray64.get64 h i)));
        h <- (BArray64.set64 h i (BArray64.get64 v i));
        i <- (i + 1);
      }
      l <- (l + 1);
    }
    return (h, ms);
  }
  proc _sha512_compress (h:BArray64.t, block:BArray128.t, ms:W64.t) : 
  BArray64.t * W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      x <-
      (BArray256.set256 x i (VPBROADCAST_2u128 (BArray128.get128 block i)));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha512_avx2 (h, x, 1, ms);
    return (h, ms);
  }
  proc _sha512_compress_one (h:BArray64.t, p:W64.t, ms:W64.t) : BArray64.t *
                                                                W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      x <-
      (BArray256.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha512_avx2 (h, x, 1, ms);
    return (h, ms);
  }
  proc _sha512_compress_two (h:BArray64.t, p:W64.t, ms:W64.t) : BArray64.t *
                                                                W64.t = {
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    mask_p <- witness;
    x <- witness;
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      x <-
      (BArray256.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      x <-
      (BArray256.set256 x i
      (VINSERTI128 (BArray256.get256 x i)
      (loadW128 Glob.mem
      (W64.to_uint ((p + (W64.of_int 128)) + (W64.of_int (16 * i)))))
      (W8.of_int 1)));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    (h, ms) <@ __sha512_avx2 (h, x, 2, ms);
    return (h, ms);
  }
  proc _sha512_compress_blocks (h:BArray64.t, p:W64.t, n:W64.t, ms:W64.t) : 
  BArray64.t * W64.t = {
    var more:bool;
    more <- ((W64.of_int 2) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress_two (h, p, ms);
      (* Erased call to unspill *)
      p <- (protect_64 p ms);
      n <- (protect_64 n ms);
      p <- (p + (W64.of_int 256));
      n <- (n - (W64.of_int 2));
      more <- ((W64.of_int 2) \ule n);
    }
    ms <- (update_msf (! more) ms);
    more <- (n <> (W64.of_int 0));
    if (more) {
      ms <- (update_msf more ms);
      (h, ms) <@ _sha512_compress_one (h, p, ms);
    } else {
      ms <- (update_msf (! more) ms);
    }
    return (h, ms);
  }
  proc __sha512_load_iv (h:BArray64.t, iv:BArray64.t) : BArray64.t = {
    var i:int;
    var t:W64.t;
    i <- 0;
    while ((i < 8)) {
      t <- (BArray64.get64 iv i);
      h <- (BArray64.set64 h i t);
      i <- (i + 1);
    }
    return h;
  }
  proc __sha512_init (h:BArray64.t) : BArray64.t = {
    
    h <@ __sha512_load_iv (h, sHA512_IV);
    return h;
  }
  proc __sha384_init (h:BArray64.t) : BArray64.t = {
    
    h <@ __sha512_load_iv (h, sHA384_IV);
    return h;
  }
  proc __sha512_224_init (h:BArray64.t) : BArray64.t = {
    
    h <@ __sha512_load_iv (h, sHA512_224_IV);
    return h;
  }
  proc __sha512_256_init (h:BArray64.t) : BArray64.t = {
    
    h <@ __sha512_load_iv (h, sHA512_256_IV);
    return h;
  }
  proc _sha512_absorb_mem (h:BArray64.t, buf:BArray128.t, total:W64.t,
                           in_0:W64.t, inlen:W64.t, ms:W64.t) : BArray64.t *
                                                                BArray128.t *
                                                                W64.t * W64.t = {
    var fill:W64.t;
    var n:W64.t;
    var full:bool;
    var off:W64.t;
    var more:bool;
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    total <- (total + inlen);
    n <- (W64.of_int 128);
    n <- (n - fill);
    n <- ((inlen \ult n) ? inlen : n);
    n <- ((fill = (W64.of_int 0)) ? fill : n);
    inlen <- (inlen - n);
    (buf, ms) <@ __fill128_mem (buf, fill, in_0, n, ms);
    fill <- (fill + n);
    in_0 <- (in_0 + n);
    full <- (fill = (W64.of_int 128));
    if (full) {
      ms <- (update_msf full ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress (h, buf, ms);
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      buf <- (protect_ptr buf ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! full) ms);
    }
    off <- (W64.of_int 0);
    n <- inlen;
    n <- (n `>>` (W8.of_int 7));
    more <- (n <> (W64.of_int 0));
    if (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress_blocks (h, in_0, n, ms);
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      buf <- (protect_ptr buf ms);
      off <- inlen;
      off <- (off `>>` (W8.of_int 7));
      off <- (off `<<` (W8.of_int 7));
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! more) ms);
    }
    inlen <- (inlen - off);
    in_0 <- (in_0 + off);
    (buf, ms) <@ __fill128_mem (buf, fill, in_0, inlen, ms);
    return (h, buf, total, ms);
  }
  proc _sha512___sha512_finalize (out:BArray64.t, h:BArray64.t,
                                  buf:BArray128.t, total:W64.t, ms:W64.t) : 
  BArray64.t * BArray64.t * BArray128.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      (buf, ms) <@ __zero128 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    (buf, ms) <@ __zero128 (buf, fill, hi, ms);
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha512_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (64 %/ 8);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <@ __bswap64 (x);
      out <- (BArray64.set64 out i x);
      i <- (i + 1);
    }
    inc <- ((64 + 7) %/ 8);
    i <- (64 %/ 8);
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      y <@ __bswap32 (y);
      out <- (BArray64.set32 out (2 * i) y);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha512____sha512_mem_from (out:BArray64.t, h:BArray64.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray64.t *
                                                            W64.t = {
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha512_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha512___sha512_finalize (out, h, buf, total, ms);
    return (out, ms);
  }
  proc _sha384___sha512_finalize (out:BArray48.t, h:BArray64.t,
                                  buf:BArray128.t, total:W64.t, ms:W64.t) : 
  BArray48.t * BArray64.t * BArray128.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      (buf, ms) <@ __zero128 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    (buf, ms) <@ __zero128 (buf, fill, hi, ms);
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha512_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (48 %/ 8);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <@ __bswap64 (x);
      out <- (BArray48.set64 out i x);
      i <- (i + 1);
    }
    inc <- ((48 + 7) %/ 8);
    i <- (48 %/ 8);
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      y <@ __bswap32 (y);
      out <- (BArray48.set32 out (2 * i) y);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha384____sha512_mem_from (out:BArray48.t, h:BArray64.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray48.t *
                                                            W64.t = {
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha512_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha384___sha512_finalize (out, h, buf, total, ms);
    return (out, ms);
  }
  proc _sha512_224___sha512_finalize (out:BArray28.t, h:BArray64.t,
                                      buf:BArray128.t, total:W64.t, ms:W64.t) : 
  BArray28.t * BArray64.t * BArray128.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      (buf, ms) <@ __zero128 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    (buf, ms) <@ __zero128 (buf, fill, hi, ms);
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha512_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (28 %/ 8);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <@ __bswap64 (x);
      out <- (BArray28.set64 out i x);
      i <- (i + 1);
    }
    inc <- ((28 + 7) %/ 8);
    i <- (28 %/ 8);
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      y <@ __bswap32 (y);
      out <- (BArray28.set32 out (2 * i) y);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha512_224____sha512_mem_from (out:BArray28.t, h:BArray64.t,
                                       in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray28.t * W64.t = {
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha512_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha512_224___sha512_finalize (out, h, buf, 
    total, ms);
    return (out, ms);
  }
  proc _sha512_256___sha512_finalize (out:BArray32.t, h:BArray64.t,
                                      buf:BArray128.t, total:W64.t, ms:W64.t) : 
  BArray32.t * BArray64.t * BArray128.t * W64.t = {
    var inc:int;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      (buf, ms) <@ __zero128 (buf, fill, hi, ms);
      (* Erased call to spill *)
      (h, ms) <@ _sha512_compress (h, buf, ms);
      (* Erased call to unspill *)
      out <- (protect_ptr out ms);
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    (buf, ms) <@ __zero128 (buf, fill, hi, ms);
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    t <@ __bswap64 (t);
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    (h, ms) <@ _sha512_compress (h, buf, ms);
    (* Erased call to unspill *)
    out <- (protect_ptr out ms);
    buf <- (protect_ptr buf ms);
    inc <- (32 %/ 8);
    i <- 0;
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <@ __bswap64 (x);
      out <- (BArray32.set64 out i x);
      i <- (i + 1);
    }
    inc <- ((32 + 7) %/ 8);
    i <- (32 %/ 8);
    while ((i < inc)) {
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      y <@ __bswap32 (y);
      out <- (BArray32.set32 out (2 * i) y);
      i <- (i + 1);
    }
    return (out, h, buf, ms);
  }
  proc _sha512_256____sha512_mem_from (out:BArray32.t, h:BArray64.t,
                                       in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray32.t * W64.t = {
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    buf <- witness;
    buf_s <- witness;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    (h, buf, total, ms) <@ _sha512_absorb_mem (h, buf, total, in_0, inlen,
    ms);
    (* Erased call to unspill *)
    (out, h, buf, ms) <@ _sha512_256___sha512_finalize (out, h, buf, 
    total, ms);
    return (out, ms);
  }
  proc _sha512_mem (out:BArray64.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray64.t * W64.t = {
    var h:BArray64.t;
    h <- witness;
    h <@ __sha512_init (h);
    (out, ms) <@ _sha512____sha512_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc _sha384_mem (out:BArray48.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray48.t * W64.t = {
    var h:BArray64.t;
    h <- witness;
    h <@ __sha384_init (h);
    (out, ms) <@ _sha384____sha512_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc _sha512_224_mem (out:BArray28.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray28.t * W64.t = {
    var h:BArray64.t;
    h <- witness;
    h <@ __sha512_224_init (h);
    (out, ms) <@ _sha512_224____sha512_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc _sha512_256_mem (out:BArray32.t, in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray32.t * W64.t = {
    var h:BArray64.t;
    h <- witness;
    h <@ __sha512_256_init (h);
    (out, ms) <@ _sha512_256____sha512_mem_from (out, h, in_0, inlen, ms);
    return (out, ms);
  }
  proc jade_hash_sha512_amd64_avx2 (out:BArray64.t, in_0:W64.t, inlen:W64.t) : 
  BArray64.t = {
    var ms:W64.t;
    ms <- (init_msf);
    (out, ms) <@ _sha512_mem (out, in_0, inlen, ms);
    return out;
  }
}.
