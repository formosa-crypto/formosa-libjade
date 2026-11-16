require import AllCore IntDiv CoreMap List Distr.

from Jasmin require import JModel_x86.

import SLH64.

from Jasmin require import Jcheck JSafety.

require import
Array2 Array4 Array8 Array16 Array28 Array32 Array40 Array48 Array64 Array80
Array112 Array128 Array144 Array208 Array256 Array272 Array512 Array1280
WArray32 WArray64 WArray256 WArray640 BArray8 BArray16 BArray28 BArray32
BArray48 BArray64 BArray112 BArray128 BArray144 BArray208 BArray256 BArray272
BArray512 BArray640 BArray1280 SBArray112_16 SBArray144_16 SBArray208_16
SBArray272_16 SBArray112_32 SBArray112_64 SBArray208_64 SBArray144_112
SBArray208_128 SBArray272_208.

abbrev  sHA512_256_IV =
(BArray64.of_list64
[(W64.of_int 2463787394917988140); (W64.of_int (-6965556091613846334));
(W64.of_int 2563595384472711505); (W64.of_int (-7622211418569250115));
(W64.of_int (-7626776825740460061)); (W64.of_int (-4729309413028513390));
(W64.of_int 3098927326965381290); (W64.of_int 1060366662362279074)]).

abbrev  sHA512_224_IV =
(BArray64.of_list64
[(W64.of_int (-8341449602262348382)); (W64.of_int 8350123849800275158);
(W64.of_int 2160240930085379202); (W64.of_int 7466358040605728719);
(W64.of_int 1111592415079452072); (W64.of_int 8638871050018654530);
(W64.of_int 4583966954114332360); (W64.of_int 1230299281376055969)]).

abbrev  sHA384_IV =
(BArray64.of_list64
[(W64.of_int (-3766243637369397544)); (W64.of_int 7105036623409894663);
(W64.of_int (-7973340178411365097)); (W64.of_int 1526699215303891257);
(W64.of_int 7436329637833083697); (W64.of_int (-8163818279084223215));
(W64.of_int (-2662702644619276377)); (W64.of_int 5167115440072839076)]).

abbrev  sHA512_IV =
(BArray64.of_list64
[(W64.of_int 7640891576956012808); (W64.of_int (-4942790177534073029));
(W64.of_int 4354685564936845355); (W64.of_int (-6534734903238641935));
(W64.of_int 5840696475078001361); (W64.of_int (-7276294671716946913));
(W64.of_int 2270897969802886507); (W64.of_int 6620516959819538809)]).

abbrev  sHA512_AVX2_BSWAP =
(BArray32.of_list64
[(W64.of_int 283686952306183); (W64.of_int 579005069656919567);
(W64.of_int 283686952306183); (W64.of_int 579005069656919567)]).

abbrev  sHA512_K =
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

abbrev  sHA224_IV =
(BArray32.of_list32
[(W32.of_int (-1056596264)); (W32.of_int 914150663); (W32.of_int 812702999);
(W32.of_int (-150054599)); (W32.of_int (-4191439)); (W32.of_int 1750603025);
(W32.of_int 1694076839); (W32.of_int (-1090891868))]).

abbrev  sHA256_IV =
(BArray32.of_list32
[(W32.of_int 1779033703); (W32.of_int (-1150833019));
(W32.of_int 1013904242); (W32.of_int (-1521486534)); (W32.of_int 1359893119);
(W32.of_int (-1694144372)); (W32.of_int 528734635); (W32.of_int 1541459225)]).

abbrev  sHA256_AVX2_HI =
(BArray32.of_list32
[(W32.of_int (-1)); (W32.of_int (-1)); (W32.of_int 50462976);
(W32.of_int 185207048); (W32.of_int (-1)); (W32.of_int (-1));
(W32.of_int 50462976); (W32.of_int 185207048)]).

abbrev  sHA256_AVX2_LO =
(BArray32.of_list32
[(W32.of_int 50462976); (W32.of_int 185207048); (W32.of_int (-1));
(W32.of_int (-1)); (W32.of_int 50462976); (W32.of_int 185207048);
(W32.of_int (-1)); (W32.of_int (-1))]).

abbrev  sHA256_AVX2_BSWAP =
(BArray32.of_list32
[(W32.of_int 66051); (W32.of_int 67438087); (W32.of_int 134810123);
(W32.of_int 202182159); (W32.of_int 66051); (W32.of_int 67438087);
(W32.of_int 134810123); (W32.of_int 202182159)]).

abbrev  sHA256_K =
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
  var tmp__trace : trace
  proc __bswap32 (x:W32.t) : W32.t * trace = {
    var trace___bswap32:trace;
    trace___bswap32 <- [];
    x <- (BSWAP_32 x);
    return (x, trace___bswap32);
  }
  proc __bswap64 (x:W64.t) : W64.t * trace = {
    var trace___bswap64:trace;
    trace___bswap64 <- [];
    x <- (BSWAP_64 x);
    return (x, trace___bswap64);
  }
  proc __fill64_mem (buf:BArray64.t, b_buf:BArray64.t, dst_:W64.t, p_:W64.t,
                     n_:W64.t, ms:W64.t) : BArray64.t * BArray64.t * W64.t *
                                           trace = {
    var dst:W64.t;
    var p:W64.t;
    var n:W64.t;
    var head:W64.t;
    var end_0:W64.t;
    var more:bool;
    var t:W64.t;
    var trace___fill64_mem:trace;
    trace___fill64_mem <- [];
    trace___fill64_mem <-
    (trace___fill64_mem ++
    [(Assert,
     (((((dst_ \ule (W64.of_int 64)) /\ (n_ \ule (W64.of_int 64))) /\
       ((dst_ + n_) \ule (W64.of_int 64))) /\
      (BArray64.is_init b_buf 0 (W64.to_uint dst_))) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p_) (W64.to_uint n_))))]);
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
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 1))]);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 1) <= 64)))]);
      b_buf <- (BArray64.set8d b_buf (W64.to_uint dst) (W8.of_int 255));
      buf <- (BArray64.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    more <- ((W64.of_int 8) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 8))]);
      t <- (loadW64 Glob.mem (W64.to_uint p));
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 8) <= 64)))]);
      b_buf <-
      (BArray64.set64d b_buf (W64.to_uint dst)
      (W64.of_int 18446744073709551615));
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
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 1))]);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      trace___fill64_mem <-
      (trace___fill64_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 1) <= 64)))]);
      b_buf <- (BArray64.set8d b_buf (W64.to_uint dst) (W8.of_int 255));
      buf <- (BArray64.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    return (buf, b_buf, ms, trace___fill64_mem);
  }
  proc __fill128_mem (buf:BArray128.t, b_buf:BArray128.t, dst_:W64.t,
                      p_:W64.t, n_:W64.t, ms:W64.t) : BArray128.t *
                                                      BArray128.t * W64.t *
                                                      trace = {
    var dst:W64.t;
    var p:W64.t;
    var n:W64.t;
    var head:W64.t;
    var end_0:W64.t;
    var more:bool;
    var t:W64.t;
    var trace___fill128_mem:trace;
    trace___fill128_mem <- [];
    trace___fill128_mem <-
    (trace___fill128_mem ++
    [(Assert,
     (((((dst_ \ule (W64.of_int 128)) /\ (n_ \ule (W64.of_int 128))) /\
       ((dst_ + n_) \ule (W64.of_int 128))) /\
      (BArray128.is_init b_buf 0 (W64.to_uint dst_))) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p_) (W64.to_uint n_))))]);
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
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 1))]);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 1) <= 128)))]);
      b_buf <- (BArray128.set8d b_buf (W64.to_uint dst) (W8.of_int 255));
      buf <- (BArray128.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    more <- ((W64.of_int 8) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 8))]);
      t <- (loadW64 Glob.mem (W64.to_uint p));
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 8) <= 128)))]);
      b_buf <-
      (BArray128.set64d b_buf (W64.to_uint dst)
      (W64.of_int 18446744073709551615));
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
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert, (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 1))]);
      t <- (zeroextu64 (loadW8 Glob.mem (W64.to_uint p)));
      trace___fill128_mem <-
      (trace___fill128_mem ++
      [(Assert,
       ((0 <= (W64.to_uint dst)) /\ (((W64.to_uint dst) + 1) <= 128)))]);
      b_buf <- (BArray128.set8d b_buf (W64.to_uint dst) (W8.of_int 255));
      buf <- (BArray128.set8 buf (W64.to_uint dst) (truncateu8 t));
      dst <- (dst + (W64.of_int 1));
      p <- (p + (W64.of_int 1));
      more <- (dst \ult end_0);
    }
    ms <- (update_msf (! more) ms);
    return (buf, b_buf, ms, trace___fill128_mem);
  }
  proc __zero64 (buf:BArray64.t, b_buf:BArray64.t, lo_:W64.t, hi:W64.t,
                 ms:W64.t) : BArray64.t * BArray64.t * W64.t * trace = {
    var lo:W64.t;
    var z:W64.t;
    var end_0:W64.t;
    var more:bool;
    var trace___zero64:trace;
    trace___zero64 <- [];
    trace___zero64 <-
    (trace___zero64 ++
    [(Assert,
     (((lo_ \ule hi) /\ (hi \ule (W64.of_int 64))) /\
     (BArray64.is_init b_buf 0 (W64.to_uint lo_))))]);
    lo <- lo_;
    z <- (W64.of_int 0);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 7));
    end_0 <- (end_0 `&` (W64.of_int 18446744073709551608));
    end_0 <- ((hi \ult end_0) ? hi : end_0);
    more <- (lo \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      trace___zero64 <-
      (trace___zero64 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 1) <= 64)))]);
      b_buf <- (BArray64.set8d b_buf (W64.to_uint lo) (W8.of_int 255));
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
      trace___zero64 <-
      (trace___zero64 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 8) <= 64)))]);
      b_buf <-
      (BArray64.set64d b_buf (W64.to_uint lo)
      (W64.of_int 18446744073709551615));
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
      trace___zero64 <-
      (trace___zero64 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 1) <= 64)))]);
      b_buf <- (BArray64.set8d b_buf (W64.to_uint lo) (W8.of_int 255));
      buf <- (BArray64.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult hi);
    }
    ms <- (update_msf (! more) ms);
    return (buf, b_buf, ms, trace___zero64);
  }
  proc __zero128 (buf:BArray128.t, b_buf:BArray128.t, lo_:W64.t, hi:W64.t,
                  ms:W64.t) : BArray128.t * BArray128.t * W64.t * trace = {
    var lo:W64.t;
    var z:W64.t;
    var end_0:W64.t;
    var more:bool;
    var trace___zero128:trace;
    trace___zero128 <- [];
    trace___zero128 <-
    (trace___zero128 ++
    [(Assert,
     (((lo_ \ule hi) /\ (hi \ule (W64.of_int 128))) /\
     (BArray128.is_init b_buf 0 (W64.to_uint lo_))))]);
    lo <- lo_;
    z <- (W64.of_int 0);
    end_0 <- lo;
    end_0 <- (end_0 + (W64.of_int 7));
    end_0 <- (end_0 `&` (W64.of_int 18446744073709551608));
    end_0 <- ((hi \ult end_0) ? hi : end_0);
    more <- (lo \ult end_0);
    while (more) {
      ms <- (update_msf more ms);
      trace___zero128 <-
      (trace___zero128 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 1) <= 128)))]);
      b_buf <- (BArray128.set8d b_buf (W64.to_uint lo) (W8.of_int 255));
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
      trace___zero128 <-
      (trace___zero128 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 8) <= 128)))]);
      b_buf <-
      (BArray128.set64d b_buf (W64.to_uint lo)
      (W64.of_int 18446744073709551615));
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
      trace___zero128 <-
      (trace___zero128 ++
      [(Assert, ((0 <= (W64.to_uint lo)) /\ (((W64.to_uint lo) + 1) <= 128)))]);
      b_buf <- (BArray128.set8d b_buf (W64.to_uint lo) (W8.of_int 255));
      buf <- (BArray128.set8 buf (W64.to_uint lo) (truncateu8 z));
      lo <- (lo + (W64.of_int 1));
      more <- (lo \ult hi);
    }
    ms <- (update_msf (! more) ms);
    return (buf, b_buf, ms, trace___zero128);
  }
  proc __sha256_avx2_round (v:BArray32.t, b_v:BArray32.t, m:BArray8.t,
                            b_m:BArray8.t, s:W32.t, t:int, x:BArray128.t,
                            b_x:BArray128.t, lo:W256.t, hi:W256.t, j:int,
                            ph:int) : BArray32.t * BArray32.t * BArray8.t *
                                      BArray8.t * W32.t * BArray128.t *
                                      BArray128.t * trace = {
    var vs:W256.t;
    var vw:W256.t;
    var y:W32.t;
    var vt:W256.t;
    var vu:W256.t;
    var z:W32.t;
    var w:W32.t;
    var b_vu:bool;
    var b_vw:bool;
    var b_vt:bool;
    var b_vs:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    var trace___sha256_avx2_round:trace;
    trace___sha256_avx2_round <- [];
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     (((((0 <= t) /\ (t < 64)) /\ (BArray32.is_init b_v 0 32)) /\
      (BArray8.is_init b_m (4 * (t %% 2)) 4)) /\
     (BArray128.is_init b_x 0 128)))]);
    b_vs <- false;
    b_vw <- false;
    b_vt <- false;
    b_vu <- false;
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert,
       ((0 <= (((j + 1) %% 4) * 32)) /\
       (((((j + 1) %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      b_vs <- true;
      vs <-
      (VPALIGNR_256 (BArray128.get256 x ((j + 1) %% 4))
      (BArray128.get256 x (j %% 4)) (W8.of_int 4));
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert,
       ((0 <= (((j + 3) %% 4) * 32)) /\
       (((((j + 3) %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert,
       ((0 <= (((j + 2) %% 4) * 32)) /\
       (((((j + 2) %% 4) * 32) + 32) <= 128)))]);
      b_vw <- true;
      vw <-
      (VPALIGNR_256 (BArray128.get256 x ((j + 3) %% 4))
      (BArray128.get256 x ((j + 2) %% 4)) (W8.of_int 4));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert,
       ((0 <= (((j + 3) %% 4) * 32)) /\
       (((((j + 3) %% 4) * 32) + 32) <= 128)))]);
      b_vs <- true;
      vs <-
      (VPSHUFD_256 (BArray128.get256 x ((j + 3) %% 4)) (W8.of_int 250));
    } else {
      
    }
    if ((ph = 2)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      b_vs <- true;
      vs <- (VPSHUFD_256 (BArray128.get256 x (j %% 4)) (W8.of_int 80));
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    v <-
    (BArray32.set32 v ((64 - t) %% 8)
    ((BArray32.get32 v ((64 - t) %% 8)) + s));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((69 - t) %% 8) * 4)) /\ (((((69 - t) %% 8) * 4) + 4) <= 32)))]);
    y <- (BArray32.get32 v ((69 - t) %% 8));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((68 - t) %% 8) * 4)) /\ (((((68 - t) %% 8) * 4) + 4) <= 32)))]);
    y <- (y `&` (BArray32.get32 v ((68 - t) %% 8)));
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vw)]);
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vw));
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vs)]);
      b_vt <- true;
      vt <- (vs \vshr32u256 (W128.of_int 7));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vs)]);
      b_vu <- true;
      vu <- (vs \vshr32u256 (W128.of_int 10));
      b_vs <- true;
      vs <- (vs \vshr64u256 (W128.of_int 17));
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((68 - t) %% 8) * 4)) /\ (((((68 - t) %% 8) * 4) + 4) <= 32)))]);
    z <- (RORX_32 (BArray32.get32 v ((68 - t) %% 8)) (W8.of_int 25));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((68 - t) %% 8) * 4)) /\ (((((68 - t) %% 8) * 4) + 4) <= 32)))]);
    w <- (RORX_32 (BArray32.get32 v ((68 - t) %% 8)) (W8.of_int 11));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    v <-
    (BArray32.set32 v ((71 - t) %% 8)
    ((BArray32.get32 v ((71 - t) %% 8)) + y));
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vs)]);
      b_vu <- true;
      vu <- (vs \vshr32u256 (W128.of_int 3));
      b_vw <- true;
      vw <- (vs \vshl32u256 (W128.of_int 14));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vs)]);
      b_vu <- true;
      vu <- (vu `^` vs);
      b_vs <- true;
      vs <- (vs \vshr64u256 (W128.of_int 2));
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((68 - t) %% 8) * 4)) /\ (((((68 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((70 - t) %% 8) * 4)) /\ (((((70 - t) %% 8) * 4) + 4) <= 32)))]);
    ( _0,  _1,  _2,  _3,  _4, y) <-
    (ANDN_32 (BArray32.get32 v ((68 - t) %% 8))
    (BArray32.get32 v ((70 - t) %% 8)));
    z <- (z `^` w);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((68 - t) %% 8) * 4)) /\ (((((68 - t) %% 8) * 4) + 4) <= 32)))]);
    w <- (RORX_32 (BArray32.get32 v ((68 - t) %% 8)) (W8.of_int 6));
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vt)]);
      b_vu <- true;
      vu <- (vu `^` vt);
      b_vt <- true;
      vt <- (vt \vshr32u256 (W128.of_int 11));
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vs)]);
      b_vu <- true;
      vu <- (vu `^` vs);
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    v <-
    (BArray32.set32 v ((71 - t) %% 8)
    ((BArray32.get32 v ((71 - t) %% 8)) + y));
    z <- (z `^` w);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 4)) /\ (((((t + 1) %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    b_m <- (BArray8.set32d b_m (((t + 1) %% 2) * 4) (W32.of_int 4294967295));
    m <- (BArray8.set32 m ((t + 1) %% 2) (BArray32.get32 v ((64 - t) %% 8)));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    y <- (RORX_32 (BArray32.get32 v ((64 - t) %% 8)) (W8.of_int 22));
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
      b_vw <- true;
      vw <- (vw \vshl32u256 (W128.of_int 11));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      b_vu <- true;
      vu <- (VPSHUFB_256 vu lo);
    } else {
      
    }
    if ((ph = 2)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      b_vu <- true;
      vu <- (VPSHUFB_256 vu hi);
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    v <-
    (BArray32.set32 v ((71 - t) %% 8)
    ((BArray32.get32 v ((71 - t) %% 8)) + z));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 4)) /\ (((((t + 1) %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 4)) /\ (((((t + 1) %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, (BArray8.is_init b_m (((t + 1) %% 2) * 4) 4))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((65 - t) %% 8) * 4)) /\ (((((65 - t) %% 8) * 4) + 4) <= 32)))]);
    b_m <- (BArray8.set32d b_m (((t + 1) %% 2) * 4) (W32.of_int 4294967295));
    m <-
    (BArray8.set32 m ((t + 1) %% 2)
    ((BArray8.get32 m ((t + 1) %% 2)) `^` (BArray32.get32 v ((65 - t) %% 8)))
    );
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    s <- (RORX_32 (BArray32.get32 v ((64 - t) %% 8)) (W8.of_int 13));
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vt)]);
      vu <- (vu `^` vt);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
    } else {
      
    }
    if (((ph = 1) \/ (ph = 2))) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vu));
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((64 - t) %% 8) * 4)) /\ (((((64 - t) %% 8) * 4) + 4) <= 32)))]);
    z <- (RORX_32 (BArray32.get32 v ((64 - t) %% 8)) (W8.of_int 2));
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((67 - t) %% 8) * 4)) /\ (((((67 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((67 - t) %% 8) * 4)) /\ (((((67 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    v <-
    (BArray32.set32 v ((67 - t) %% 8)
    ((BArray32.get32 v ((67 - t) %% 8)) + (BArray32.get32 v ((71 - t) %% 8)))
    );
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 4)) /\ ((((t %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 4)) /\ ((((t %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, (BArray8.is_init b_m ((t %% 2) * 4) 4))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 4)) /\ (((((t + 1) %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, (BArray8.is_init b_m (((t + 1) %% 2) * 4) 4))]);
    b_m <- (BArray8.set32d b_m ((t %% 2) * 4) (W32.of_int 4294967295));
    m <-
    (BArray8.set32 m (t %% 2)
    ((BArray8.get32 m (t %% 2)) `&` (BArray8.get32 m ((t + 1) %% 2))));
    s <- (s `^` y);
    if ((ph = 0)) {
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++
      [(Assert, ((0 <= ((j %% 4) * 32)) /\ ((((j %% 4) * 32) + 32) <= 128)))]);
      trace___sha256_avx2_round <-
      (trace___sha256_avx2_round ++ [(Assert, b_vu)]);
      x <-
      (BArray128.set256 x (j %% 4)
      ((BArray128.get256 x (j %% 4)) \vadd32u256 vu));
    } else {
      
    }
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 4)) /\ ((((t %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 4)) /\ ((((t %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, (BArray8.is_init b_m ((t %% 2) * 4) 4))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((65 - t) %% 8) * 4)) /\ (((((65 - t) %% 8) * 4) + 4) <= 32)))]);
    b_m <- (BArray8.set32d b_m ((t %% 2) * 4) (W32.of_int 4294967295));
    m <-
    (BArray8.set32 m (t %% 2)
    ((BArray8.get32 m (t %% 2)) `^` (BArray32.get32 v ((65 - t) %% 8))));
    s <- (s `^` z);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert,
     ((0 <= (((71 - t) %% 8) * 4)) /\ (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 4)) /\ ((((t %% 2) * 4) + 4) <= 8)))]);
    trace___sha256_avx2_round <-
    (trace___sha256_avx2_round ++
    [(Assert, (BArray8.is_init b_m ((t %% 2) * 4) 4))]);
    v <-
    (BArray32.set32 v ((71 - t) %% 8)
    ((BArray32.get32 v ((71 - t) %% 8)) + (BArray8.get32 m (t %% 2))));
    b_v <- (BArray32.init_arr (W8.of_int 255));
    b_x <- (BArray128.init_arr (W8.of_int 255));
    return (v, b_v, m, b_m, s, x, b_x, trace___sha256_avx2_round);
  }
  proc __sha256_avx2 (h:BArray32.t, b_h:BArray32.t, x:BArray128.t,
                      b_x:BArray128.t, nb:int, ms:W64.t) : BArray32.t *
                                                           BArray32.t *
                                                           W64.t * trace = {
    var aux_4:BArray128.t;
    var aux_5:BArray128.t;
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray8.t;
    var aux_2:BArray8.t;
    var aux_3:W32.t;
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
    var param:int;
    var param_0:int;
    var param_1:W256.t;
    var param_2:W256.t;
    var param_3:BArray128.t;
    var param_4:int;
    var param_5:W32.t;
    var param_6:BArray8.t;
    var param_7:BArray32.t;
    var result:BArray128.t;
    var result_0:W32.t;
    var result_1:BArray8.t;
    var result_2:BArray32.t;
    var param_8:int;
    var param_9:int;
    var param_10:W256.t;
    var param_11:W256.t;
    var param_12:BArray128.t;
    var param_13:int;
    var param_14:W32.t;
    var param_15:BArray8.t;
    var param_16:BArray32.t;
    var result_3:BArray128.t;
    var result_4:W32.t;
    var result_5:BArray8.t;
    var result_6:BArray32.t;
    var b_v:BArray32.t;
    var b_wk:BArray512.t;
    var b_result:BArray128.t;
    var b_m:BArray8.t;
    var b_result_0:BArray8.t;
    var b_result_1:BArray32.t;
    var b_param:BArray8.t;
    var b_param_0:BArray32.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray8.t;
    var b_result_4:BArray32.t;
    var b_param_1:BArray8.t;
    var b_param_2:BArray32.t;
    var trace___sha256_avx2:trace;
    b_m <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    b_result_4 <- witness;
    b_v <- witness;
    b_wk <- witness;
    hi_p <- witness;
    lo_p <- witness;
    m <- witness;
    param_3 <- witness;
    param_6 <- witness;
    param_7 <- witness;
    param_12 <- witness;
    param_15 <- witness;
    param_16 <- witness;
    result <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    v <- witness;
    wk <- witness;
    trace___sha256_avx2 <- [];
    trace___sha256_avx2 <-
    (trace___sha256_avx2 ++
    [(Assert,
     ((((0 <= nb) /\ (nb <= 2)) /\ (BArray32.is_init b_h 0 32)) /\
     (BArray128.is_init b_x 0 128)))]);
    b_m <- (BArray8.init_arr (W8.of_int 0));
    b_v <- (BArray32.init_arr (W8.of_int 0));
    b_wk <- (BArray512.init_arr (W8.of_int 0));
    i <- 0;
    while ((i < 4)) {
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++
      [(Assert, ((0 <= (i * 16)) /\ (((i * 16) + 16) <= 256)))]);
      k <- (VPBROADCAST_2u128 (BArray256.get128 sHA256_K i));
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      k <- (k \vadd32u256 (BArray128.get256 x i));
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 512)))]);
      b_wk <-
      (BArray512.set256d b_wk (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      wk <- (BArray512.set256 wk i k);
      i <- (i + 1);
    }
    lo_p <- sHA256_AVX2_LO;
    lo <- (BArray32.get256 lo_p 0);
    hi_p <- sHA256_AVX2_HI;
    hi <- (BArray32.get256 hi_p 0);
    i <- 0;
    while ((i < 8)) {
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      b_v <- (BArray32.set32d b_v (i * 4) (W32.of_int 4294967295));
      v <- (BArray32.set32 v i (BArray32.get32 h i));
      i <- (i + 1);
    }
    inc <- nb;
    l <- 0;
    while ((l < inc)) {
      (* Erased call to spill *)
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++ [(Assert, (BArray32.is_init b_v 4 4))]);
      b_m <- (BArray8.set32d b_m 0 (W32.of_int 4294967295));
      m <- (BArray8.set32 m 0 (BArray32.get32 v 1));
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++ [(Assert, (BArray8.is_init b_m 0 4))]);
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++ [(Assert, (BArray32.is_init b_v 8 4))]);
      b_m <- (BArray8.set32d b_m 0 (W32.of_int 4294967295));
      m <-
      (BArray8.set32 m 0 ((BArray8.get32 m 0) `^` (BArray32.get32 v 2)));
      s <- (W32.of_int 0);
      t <- 0;
      while ((t < 64)) {
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert,
         ((0 <= (((71 - t) %% 8) * 4)) /\
         (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert,
         ((0 <= (((71 - t) %% 8) * 4)) /\
         (((((71 - t) %% 8) * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, (BArray32.is_init b_v (((71 - t) %% 8) * 4) 4))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert,
         ((0 <= ((((8 * (t %/ 4)) + (4 * l)) + (t %% 4)) * 4)) /\
         ((((((8 * (t %/ 4)) + (4 * l)) + (t %% 4)) * 4) + 4) <= 512)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert,
         (BArray512.is_init b_wk
         ((((8 * (t %/ 4)) + (4 * l)) + (t %% 4)) * 4) 4))]);
        b_v <-
        (BArray32.set32d b_v (((71 - t) %% 8) * 4) (W32.of_int 4294967295));
        v <-
        (BArray32.set32 v ((71 - t) %% 8)
        ((BArray32.get32 v ((71 - t) %% 8)) +
        (BArray512.get32 wk (((8 * (t %/ 4)) + (4 * l)) + (t %% 4)))));
        if (((l = 0) /\ (t < 48))) {
          b_param_0 <- b_v;
          param_7 <- v;
          b_param <- b_m;
          param_6 <- m;
          param_5 <- s;
          param_4 <- t;
          param_3 <- x;
          param_2 <- lo;
          param_1 <- hi;
          param_0 <- (t %/ 4);
          param <- (t %% 4);
          (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ 
          __sha256_avx2_round (param_7, b_param_0, param_6, b_param, 
          param_5, param_4, param_3, (BArray128.init_arr (W8.of_int 255)),
          param_2, param_1, param_0, param);
          result_2 <- aux;
          b_result_1 <- aux_0;
          result_1 <- aux_1;
          b_result_0 <- aux_2;
          result_0 <- aux_3;
          result <- aux_4;
          b_result <- aux_5;
          trace___sha256_avx2 <- (trace___sha256_avx2 ++ tmp__trace);
          trace___sha256_avx2 <-
          (trace___sha256_avx2 ++
          [(Assert,
           (((BArray32.is_init b_result_1 0 32) /\
            (BArray8.is_init b_result_0 0 8)) /\
           (BArray128.is_init b_result 0 128)))]);
          b_v <- (BArray32.init_arr (W8.of_int 255));
          v <- result_2;
          b_m <- (BArray8.init_arr (W8.of_int 255));
          m <- result_1;
          s <- result_0;
          x <- result;
        } else {
          b_param_2 <- b_v;
          param_16 <- v;
          b_param_1 <- b_m;
          param_15 <- m;
          param_14 <- s;
          param_13 <- t;
          param_12 <- x;
          param_11 <- lo;
          param_10 <- hi;
          param_9 <- 0;
          param_8 <- 3;
          (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ 
          __sha256_avx2_round (param_16, b_param_2, param_15, b_param_1,
          param_14, param_13, param_12, (BArray128.init_arr (W8.of_int 255)),
          param_11, param_10, param_9, param_8);
          result_6 <- aux;
          b_result_4 <- aux_0;
          result_5 <- aux_1;
          b_result_3 <- aux_2;
          result_4 <- aux_3;
          result_3 <- aux_4;
          b_result_2 <- aux_5;
          trace___sha256_avx2 <- (trace___sha256_avx2 ++ tmp__trace);
          trace___sha256_avx2 <-
          (trace___sha256_avx2 ++
          [(Assert,
           (((BArray32.is_init b_result_4 0 32) /\
            (BArray8.is_init b_result_3 0 8)) /\
           (BArray128.is_init b_result_2 0 128)))]);
          b_v <- (BArray32.init_arr (W8.of_int 255));
          v <- result_6;
          b_m <- (BArray8.init_arr (W8.of_int 255));
          m <- result_5;
          s <- result_4;
          x <- result_3;
        }
        if ((((l = 0) /\ (t < 48)) /\ ((t %% 4) = 2))) {
          trace___sha256_avx2 <-
          (trace___sha256_avx2 ++
          [(Assert,
           ((0 <= ((4 + (t %/ 4)) * 16)) /\
           ((((4 + (t %/ 4)) * 16) + 16) <= 256)))]);
          k <-
          (VPBROADCAST_2u128 (BArray256.get128 sHA256_K (4 + (t %/ 4))));
          trace___sha256_avx2 <-
          (trace___sha256_avx2 ++
          [(Assert,
           ((0 <= (((t %/ 4) %% 4) * 32)) /\
           (((((t %/ 4) %% 4) * 32) + 32) <= 128)))]);
          k <- (k \vadd32u256 (BArray128.get256 x ((t %/ 4) %% 4)));
          trace___sha256_avx2 <-
          (trace___sha256_avx2 ++
          [(Assert,
           ((0 <= ((4 + (t %/ 4)) * 32)) /\
           ((((4 + (t %/ 4)) * 32) + 32) <= 512)))]);
          b_wk <-
          (BArray512.set256d b_wk ((4 + (t %/ 4)) * 32)
          (W256.of_int
          115792089237316195423570985008687907853269984665640564039457584007913129639935
          ));
          wk <- (BArray512.set256 wk (4 + (t %/ 4)) k);
        } else {
          
        }
        t <- (t + 1);
      }
      trace___sha256_avx2 <-
      (trace___sha256_avx2 ++ [(Assert, (BArray32.is_init b_v 0 4))]);
      b_v <- (BArray32.set32d b_v 0 (W32.of_int 4294967295));
      v <- (BArray32.set32 v 0 ((BArray32.get32 v 0) + s));
      (* Erased call to unspill *)
      h <- (protect_ptr h ms);
      i <- 0;
      while ((i < 8)) {
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++ [(Assert, (BArray32.is_init b_v (i * 4) 4))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        b_v <- (BArray32.set32d b_v (i * 4) (W32.of_int 4294967295));
        v <-
        (BArray32.set32 v i ((BArray32.get32 v i) + (BArray32.get32 h i)));
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        trace___sha256_avx2 <-
        (trace___sha256_avx2 ++ [(Assert, (BArray32.is_init b_v (i * 4) 4))]);
        h <- (BArray32.set32 h i (BArray32.get32 v i));
        i <- (i + 1);
      }
      l <- (l + 1);
    }
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace___sha256_avx2);
  }
  proc _sha256_compress (h:BArray32.t, b_h:BArray32.t, block:BArray64.t,
                         b_block:BArray64.t, ms:W64.t) : BArray32.t *
                                                         BArray32.t * W64.t *
                                                         trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray128.t;
    var param_2:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray128.t;
    var b_x:BArray128.t;
    var trace__sha256_compress:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha256_compress <- [];
    trace__sha256_compress <-
    (trace__sha256_compress ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\ (BArray64.is_init b_block 0 64)))]);
    b_x <- (BArray128.init_arr (W8.of_int 0));
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      trace__sha256_compress <-
      (trace__sha256_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress <-
      (trace__sha256_compress ++
      [(Assert, ((0 <= (i * 16)) /\ (((i * 16) + 16) <= 64)))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray128.set256 x i (VPBROADCAST_2u128 (BArray64.get128 block i)));
      trace__sha256_compress <-
      (trace__sha256_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress <-
      (trace__sha256_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress <-
      (trace__sha256_compress ++
      [(Assert, (BArray128.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 1;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha256_avx2 (param_2,
    (BArray32.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha256_compress <- (trace__sha256_compress ++ tmp__trace);
    trace__sha256_compress <-
    (trace__sha256_compress ++ [(Assert, (BArray32.is_init b_result 0 32))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha256_compress);
  }
  proc _sha256_compress_one (h:BArray32.t, b_h:BArray32.t, p:W64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray128.t;
    var param_2:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray128.t;
    var b_x:BArray128.t;
    var trace__sha256_compress_one:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha256_compress_one <- [];
    trace__sha256_compress_one <-
    (trace__sha256_compress_one ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 64)))]);
    b_x <- (BArray128.init_arr (W8.of_int 0));
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      trace__sha256_compress_one <-
      (trace__sha256_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_one <-
      (trace__sha256_compress_one ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint (p + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray128.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      trace__sha256_compress_one <-
      (trace__sha256_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_one <-
      (trace__sha256_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_one <-
      (trace__sha256_compress_one ++
      [(Assert, (BArray128.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 1;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha256_avx2 (param_2,
    (BArray32.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha256_compress_one <- (trace__sha256_compress_one ++ tmp__trace);
    trace__sha256_compress_one <-
    (trace__sha256_compress_one ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha256_compress_one);
  }
  proc _sha256_compress_two (h:BArray32.t, b_h:BArray32.t, p:W64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray128.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray128.t;
    var param_2:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray128.t;
    var b_x:BArray128.t;
    var trace__sha256_compress_two:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha256_compress_two <- [];
    trace__sha256_compress_two <-
    (trace__sha256_compress_two ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 128)))]);
    b_x <- (BArray128.init_arr (W8.of_int 0));
    mask_p <- sHA256_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 4)) {
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint (p + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray128.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, (BArray128.is_init b_x (i * 32) 32))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint ((p + (W64.of_int 64)) + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray128.set256 x i
      (VINSERTI128 (BArray128.get256 x i)
      (loadW128 Glob.mem
      (W64.to_uint ((p + (W64.of_int 64)) + (W64.of_int (16 * i)))))
      (W8.of_int 1)));
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 128)))]);
      trace__sha256_compress_two <-
      (trace__sha256_compress_two ++
      [(Assert, (BArray128.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray128.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray128.set256 x i (VPSHUFB_256 (BArray128.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 2;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha256_avx2 (param_2,
    (BArray32.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha256_compress_two <- (trace__sha256_compress_two ++ tmp__trace);
    trace__sha256_compress_two <-
    (trace__sha256_compress_two ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha256_compress_two);
  }
  proc _sha256_compress_blocks (h:BArray32.t, b_h:BArray32.t, p:W64.t,
                                n:W64.t, ms:W64.t) : BArray32.t *
                                                     BArray32.t * W64.t *
                                                     trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var more:bool;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var b_result:BArray32.t;
    var b_result_0:BArray32.t;
    var trace__sha256_compress_blocks:trace;
    b_result <- witness;
    b_result_0 <- witness;
    param_1 <- witness;
    param_4 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    trace__sha256_compress_blocks <- [];
    trace__sha256_compress_blocks <-
    (trace__sha256_compress_blocks ++
    [(Assert,
     (((BArray32.is_init b_h 0 32) /\
      (n \ult (W64.of_int 288230376151711744))) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p)
     (W64.to_uint ((W64.of_int 64) * n)))))]);
    more <- ((W64.of_int 2) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      param_1 <- h;
      param_0 <- p;
      param <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress_two (param_1,
      (BArray32.init_arr (W8.of_int 255)), param_0, param);
      result_0 <- aux;
      b_result_0 <- aux_0;
      result <- aux_1;
      trace__sha256_compress_blocks <-
      (trace__sha256_compress_blocks ++ tmp__trace);
      trace__sha256_compress_blocks <-
      (trace__sha256_compress_blocks ++
      [(Assert, (BArray32.is_init b_result_0 0 32))]);
      h <- result_0;
      ms <- result;
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
      param_4 <- h;
      param_3 <- p;
      param_2 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress_one (param_4,
      (BArray32.init_arr (W8.of_int 255)), param_3, param_2);
      result_2 <- aux;
      b_result <- aux_0;
      result_1 <- aux_1;
      trace__sha256_compress_blocks <-
      (trace__sha256_compress_blocks ++ tmp__trace);
      trace__sha256_compress_blocks <-
      (trace__sha256_compress_blocks ++
      [(Assert, (BArray32.is_init b_result 0 32))]);
      h <- result_2;
      ms <- result_1;
    } else {
      ms <- (update_msf (! more) ms);
    }
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha256_compress_blocks);
  }
  proc __sha256_init (h:BArray32.t, b_h:BArray32.t) : BArray32.t *
                                                      BArray32.t * trace = {
    var iv:BArray32.t;
    var i:int;
    var t:W32.t;
    var trace___sha256_init:trace;
    iv <- witness;
    trace___sha256_init <- [];
    iv <- sHA256_IV;
    i <- 0;
    while ((i < 8)) {
      trace___sha256_init <-
      (trace___sha256_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      t <- (BArray32.get32 iv i);
      trace___sha256_init <-
      (trace___sha256_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      b_h <- (BArray32.set32d b_h (i * 4) (W32.of_int 4294967295));
      h <- (BArray32.set32 h i t);
      i <- (i + 1);
    }
    return (h, b_h, trace___sha256_init);
  }
  proc __sha224_init (h:BArray32.t, b_h:BArray32.t) : BArray32.t *
                                                      BArray32.t * trace = {
    var iv:BArray32.t;
    var i:int;
    var t:W32.t;
    var trace___sha224_init:trace;
    iv <- witness;
    trace___sha224_init <- [];
    iv <- sHA224_IV;
    i <- 0;
    while ((i < 8)) {
      trace___sha224_init <-
      (trace___sha224_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      t <- (BArray32.get32 iv i);
      trace___sha224_init <-
      (trace___sha224_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      b_h <- (BArray32.set32d b_h (i * 4) (W32.of_int 4294967295));
      h <- (BArray32.set32 h i t);
      i <- (i + 1);
    }
    return (h, b_h, trace___sha224_init);
  }
  proc _sha256_absorb_mem (h:BArray32.t, b_h:BArray32.t, buf:BArray64.t,
                           b_buf:BArray64.t, total:W64.t, in_0:W64.t,
                           inlen:W64.t, ms:W64.t) : BArray32.t * BArray32.t *
                                                    BArray64.t * BArray64.t *
                                                    W64.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var n:W64.t;
    var full:bool;
    var off:W64.t;
    var more:bool;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_4:W64.t;
    var param_5:BArray64.t;
    var param_6:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:BArray32.t;
    var result_3:W64.t;
    var result_4:BArray32.t;
    var param_11:W64.t;
    var param_12:W64.t;
    var param_13:W64.t;
    var param_14:W64.t;
    var param_15:BArray64.t;
    var result_5:W64.t;
    var result_6:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param_0:BArray64.t;
    var b_result_2:BArray64.t;
    var b_param_1:BArray64.t;
    var trace__sha256_absorb_mem:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_3 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_10 <- witness;
    param_15 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_6 <- witness;
    trace__sha256_absorb_mem <- [];
    trace__sha256_absorb_mem <-
    (trace__sha256_absorb_mem ++
    [(Assert,
     (((BArray32.is_init b_h 0 32) /\
      (BArray64.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 64))))) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    total <- (total + inlen);
    n <- (W64.of_int 64);
    n <- (n - fill);
    n <- ((inlen \ult n) ? inlen : n);
    n <- ((fill = (W64.of_int 0)) ? fill : n);
    inlen <- (inlen - n);
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- fill;
    param_1 <- in_0;
    param_0 <- n;
    param <- ms;
    (result_0, b_result_2, result, tmp__trace) <@ __fill64_mem (param_3,
    b_param_1, param_2, param_1, param_0, param);
    trace__sha256_absorb_mem <- (trace__sha256_absorb_mem ++ tmp__trace);
    trace__sha256_absorb_mem <-
    (trace__sha256_absorb_mem ++
    [(Assert,
     (BArray64.is_init b_result_2 0 (W64.to_uint (param_2 + param_0))))]);
    b_buf <- b_result_2;
    buf <- result_0;
    ms <- result;
    fill <- (fill + n);
    in_0 <- (in_0 + n);
    full <- (fill = (W64.of_int 64));
    if (full) {
      ms <- (update_msf full ms);
      (* Erased call to spill *)
      param_6 <- h;
      b_param_0 <- b_buf;
      param_5 <- buf;
      param_4 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_6,
      (BArray32.init_arr (W8.of_int 255)), param_5, b_param_0, param_4);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha256_absorb_mem <- (trace__sha256_absorb_mem ++ tmp__trace);
      trace__sha256_absorb_mem <-
      (trace__sha256_absorb_mem ++
      [(Assert, (BArray32.is_init b_result_1 0 32))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      b_buf <- b_buf;
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
      param_10 <- h;
      param_9 <- in_0;
      param_8 <- n;
      param_7 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress_blocks (param_10,
      (BArray32.init_arr (W8.of_int 255)), param_9, param_8, param_7);
      result_4 <- aux;
      b_result_0 <- aux_0;
      result_3 <- aux_1;
      trace__sha256_absorb_mem <- (trace__sha256_absorb_mem ++ tmp__trace);
      trace__sha256_absorb_mem <-
      (trace__sha256_absorb_mem ++
      [(Assert, (BArray32.is_init b_result_0 0 32))]);
      h <- result_4;
      ms <- result_3;
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      b_buf <- b_buf;
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
    b_param <- b_buf;
    param_15 <- buf;
    param_14 <- fill;
    param_13 <- in_0;
    param_12 <- inlen;
    param_11 <- ms;
    (result_6, b_result, result_5, tmp__trace) <@ __fill64_mem (param_15,
    b_param, param_14, param_13, param_12, param_11);
    trace__sha256_absorb_mem <- (trace__sha256_absorb_mem ++ tmp__trace);
    trace__sha256_absorb_mem <-
    (trace__sha256_absorb_mem ++
    [(Assert,
     (BArray64.is_init b_result 0 (W64.to_uint (param_14 + param_12))))]);
    b_buf <- b_result;
    buf <- result_6;
    ms <- result_5;
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (h, b_h, buf, b_buf, total, ms, trace__sha256_absorb_mem);
  }
  proc _sha256___sha256_finalize (out:BArray32.t, b_out:BArray32.t,
                                  h:BArray32.t, b_h:BArray32.t,
                                  buf:BArray64.t, b_buf:BArray64.t,
                                  total:W64.t, ms:W64.t) : BArray32.t *
                                                           BArray32.t *
                                                           BArray32.t *
                                                           BArray32.t *
                                                           BArray64.t *
                                                           BArray64.t *
                                                           W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_3:W64.t;
    var param_4:BArray64.t;
    var param_5:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var param_12:BArray64.t;
    var param_13:BArray32.t;
    var result_6:W64.t;
    var result_7:BArray32.t;
    var param_14:W32.t;
    var result_8:W32.t;
    var b_result:BArray32.t;
    var b_param:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var b_result_1:BArray32.t;
    var b_param_1:BArray64.t;
    var b_result_2:BArray64.t;
    var b_param_2:BArray64.t;
    var trace__sha256___sha256_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_12 <- witness;
    param_13 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_7 <- witness;
    trace__sha256___sha256_finalize <- [];
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (BArray64.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 64))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    t <- (W64.of_int 128);
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 64)))]);
    b_buf <- (BArray64.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray64.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 56) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 64);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero64 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++ tmp__trace);
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++
      [(Assert, (BArray64.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_5,
      (BArray32.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++ tmp__trace);
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++
      [(Assert, (BArray32.is_init b_result_1 0 32))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 56);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero64 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++ tmp__trace);
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++
    [(Assert, (BArray64.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray64.set64d b_buf 56 (W64.of_int 18446744073709551615));
    buf <- (BArray64.set64d buf 56 t);
    (* Erased call to spill *)
    param_13 <- h;
    b_param <- b_buf;
    param_12 <- buf;
    param_11 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_13,
    (BArray32.init_arr (W8.of_int 255)), param_12, b_param, param_11);
    result_7 <- aux;
    b_result <- aux_0;
    result_6 <- aux_1;
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++ tmp__trace);
    trace__sha256___sha256_finalize <-
    (trace__sha256___sha256_finalize ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    h <- result_7;
    ms <- result_6;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 8)) {
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      x <- (BArray32.get32 h i);
      param_14 <- x;
      (result_8, tmp__trace) <@ __bswap32 (param_14);
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++ tmp__trace);
      x <- result_8;
      trace__sha256___sha256_finalize <-
      (trace__sha256___sha256_finalize ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      b_out <- (BArray32.set32d b_out (i * 4) (W32.of_int 4294967295));
      out <- (BArray32.set32 out i x);
      i <- (i + 1);
    }
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha256___sha256_finalize);
  }
  proc _sha256____sha256_mem_from (out:BArray32.t, b_out:BArray32.t,
                                   h:BArray32.t, b_h:BArray32.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray32.t *
                                                            BArray32.t *
                                                            W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_5:BArray32.t;
    var aux_6:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray64.t;
    var buf:BArray64.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray32.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray64.t;
    var result_2:BArray32.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray64.t;
    var param_8:BArray32.t;
    var param_9:BArray32.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var result_5:BArray32.t;
    var result_6:BArray32.t;
    var b_buf:BArray64.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_result_2:BArray64.t;
    var b_result_3:BArray32.t;
    var b_param_1:BArray64.t;
    var b_buf_s:BArray64.t;
    var trace__sha256____sha256_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha256____sha256_mem_from <- [];
    trace__sha256____sha256_mem_from <-
    (trace__sha256____sha256_mem_from ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray64.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha256_absorb_mem (
    param_4, (BArray32.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha256____sha256_mem_from <-
    (trace__sha256____sha256_mem_from ++ tmp__trace);
    trace__sha256____sha256_mem_from <-
    (trace__sha256____sha256_mem_from ++
    [(Assert,
     (((BArray32.is_init b_result_3 0 32) /\
      (BArray64.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 64))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux, aux_0, aux_5, aux_6, aux_1, aux_2, aux_3, tmp__trace) <@ _sha256___sha256_finalize (
    param_9, b_param_0, param_8, (BArray32.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux;
    b_result_1 <- aux_0;
    result_5 <- aux_5;
    b_result_0 <- aux_6;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha256____sha256_mem_from <-
    (trace__sha256____sha256_mem_from ++ tmp__trace);
    trace__sha256____sha256_mem_from <-
    (trace__sha256____sha256_mem_from ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha256____sha256_mem_from);
  }
  proc _sha224___sha256_finalize (out:BArray28.t, b_out:BArray28.t,
                                  h:BArray32.t, b_h:BArray32.t,
                                  buf:BArray64.t, b_buf:BArray64.t,
                                  total:W64.t, ms:W64.t) : BArray28.t *
                                                           BArray28.t *
                                                           BArray32.t *
                                                           BArray32.t *
                                                           BArray64.t *
                                                           BArray64.t *
                                                           W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_3:W64.t;
    var param_4:BArray64.t;
    var param_5:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var param_12:BArray64.t;
    var param_13:BArray32.t;
    var result_6:W64.t;
    var result_7:BArray32.t;
    var param_14:W32.t;
    var result_8:W32.t;
    var b_result:BArray32.t;
    var b_param:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var b_result_1:BArray32.t;
    var b_param_1:BArray64.t;
    var b_result_2:BArray64.t;
    var b_param_2:BArray64.t;
    var trace__sha224___sha256_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_12 <- witness;
    param_13 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_7 <- witness;
    trace__sha224___sha256_finalize <- [];
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (BArray64.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 64))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 63));
    t <- (W64.of_int 128);
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 64)))]);
    b_buf <- (BArray64.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray64.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 56) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 64);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero64 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++ tmp__trace);
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++
      [(Assert, (BArray64.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_5,
      (BArray32.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++ tmp__trace);
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++
      [(Assert, (BArray32.is_init b_result_1 0 32))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 56);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero64 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++ tmp__trace);
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++
    [(Assert, (BArray64.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray64.set64d b_buf 56 (W64.of_int 18446744073709551615));
    buf <- (BArray64.set64d buf 56 t);
    (* Erased call to spill *)
    param_13 <- h;
    b_param <- b_buf;
    param_12 <- buf;
    param_11 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_13,
    (BArray32.init_arr (W8.of_int 255)), param_12, b_param, param_11);
    result_7 <- aux;
    b_result <- aux_0;
    result_6 <- aux_1;
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++ tmp__trace);
    trace__sha224___sha256_finalize <-
    (trace__sha224___sha256_finalize ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    h <- result_7;
    ms <- result_6;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 7)) {
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      x <- (BArray32.get32 h i);
      param_14 <- x;
      (result_8, tmp__trace) <@ __bswap32 (param_14);
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++ tmp__trace);
      x <- result_8;
      trace__sha224___sha256_finalize <-
      (trace__sha224___sha256_finalize ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 28)))]);
      b_out <- (BArray28.set32d b_out (i * 4) (W32.of_int 4294967295));
      out <- (BArray28.set32 out i x);
      i <- (i + 1);
    }
    b_h <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha224___sha256_finalize);
  }
  proc _sha224____sha256_mem_from (out:BArray28.t, b_out:BArray28.t,
                                   h:BArray32.t, b_h:BArray32.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray28.t *
                                                            BArray28.t *
                                                            W64.t * trace = {
    var aux_5:BArray28.t;
    var aux_6:BArray28.t;
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray64.t;
    var buf:BArray64.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray32.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray64.t;
    var result_2:BArray32.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray64.t;
    var param_8:BArray32.t;
    var param_9:BArray28.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var result_5:BArray32.t;
    var result_6:BArray28.t;
    var b_buf:BArray64.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray28.t;
    var b_param:BArray64.t;
    var b_param_0:BArray28.t;
    var b_result_2:BArray64.t;
    var b_result_3:BArray32.t;
    var b_param_1:BArray64.t;
    var b_buf_s:BArray64.t;
    var trace__sha224____sha256_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha224____sha256_mem_from <- [];
    trace__sha224____sha256_mem_from <-
    (trace__sha224____sha256_mem_from ++
    [(Assert,
     ((BArray32.is_init b_h 0 32) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray64.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha256_absorb_mem (
    param_4, (BArray32.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha224____sha256_mem_from <-
    (trace__sha224____sha256_mem_from ++ tmp__trace);
    trace__sha224____sha256_mem_from <-
    (trace__sha224____sha256_mem_from ++
    [(Assert,
     (((BArray32.is_init b_result_3 0 32) /\
      (BArray64.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 64))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux_5, aux_6, aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ _sha224___sha256_finalize (
    param_9, b_param_0, param_8, (BArray32.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux_5;
    b_result_1 <- aux_6;
    result_5 <- aux;
    b_result_0 <- aux_0;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha224____sha256_mem_from <-
    (trace__sha224____sha256_mem_from ++ tmp__trace);
    trace__sha224____sha256_mem_from <-
    (trace__sha224____sha256_mem_from ++
    [(Assert,
     (((BArray28.is_init b_result_1 0 28) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray28.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha224____sha256_mem_from);
  }
  proc _sha256_mem (out:BArray32.t, b_out:BArray32.t, in_0:W64.t,
                    inlen:W64.t, ms:W64.t) : BArray32.t * BArray32.t *
                                             W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var h:BArray32.t;
    var param:BArray32.t;
    var result:BArray32.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray32.t;
    var param_4:BArray32.t;
    var result_0:W64.t;
    var result_1:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray32.t;
    var b_h:BArray32.t;
    var b_result_0:BArray32.t;
    var b_param_0:BArray32.t;
    var trace__sha256_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha256_mem <- [];
    trace__sha256_mem <-
    (trace__sha256_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray32.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha256_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha256_mem <- (trace__sha256_mem ++ tmp__trace);
    trace__sha256_mem <-
    (trace__sha256_mem ++ [(Assert, (BArray32.is_init b_result_0 0 32))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha256____sha256_mem_from (
    param_4, b_param, param_3, (BArray32.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha256_mem <- (trace__sha256_mem ++ tmp__trace);
    trace__sha256_mem <-
    (trace__sha256_mem ++ [(Assert, (BArray32.is_init b_result 0 32))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha256_mem);
  }
  proc _sha224_mem (out:BArray28.t, b_out:BArray28.t, in_0:W64.t,
                    inlen:W64.t, ms:W64.t) : BArray28.t * BArray28.t *
                                             W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var h:BArray32.t;
    var param:BArray32.t;
    var result:BArray32.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray32.t;
    var param_4:BArray28.t;
    var result_0:W64.t;
    var result_1:BArray28.t;
    var b_result:BArray28.t;
    var b_param:BArray28.t;
    var b_h:BArray32.t;
    var b_result_0:BArray32.t;
    var b_param_0:BArray32.t;
    var trace__sha224_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha224_mem <- [];
    trace__sha224_mem <-
    (trace__sha224_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray32.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha224_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha224_mem <- (trace__sha224_mem ++ tmp__trace);
    trace__sha224_mem <-
    (trace__sha224_mem ++ [(Assert, (BArray32.is_init b_result_0 0 32))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha224____sha256_mem_from (
    param_4, b_param, param_3, (BArray32.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha224_mem <- (trace__sha224_mem ++ tmp__trace);
    trace__sha224_mem <-
    (trace__sha224_mem ++ [(Assert, (BArray28.is_init b_result 0 28))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray28.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha224_mem);
  }
  proc __sha512_avx2_round (v:BArray64.t, b_v:BArray64.t, m:BArray16.t,
                            b_m:BArray16.t, s:W64.t, t:int, x:BArray256.t,
                            b_x:BArray256.t, j:int, ph:int) : BArray64.t *
                                                              BArray64.t *
                                                              BArray16.t *
                                                              BArray16.t *
                                                              W64.t *
                                                              BArray256.t *
                                                              BArray256.t *
                                                              trace = {
    var vs:W256.t;
    var vw:W256.t;
    var vu:W256.t;
    var y:W64.t;
    var vt:W256.t;
    var z:W64.t;
    var w:W64.t;
    var b_vu:bool;
    var b_vw:bool;
    var b_vt:bool;
    var b_vs:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    var trace___sha512_avx2_round:trace;
    trace___sha512_avx2_round <- [];
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     (((((0 <= t) /\ (t < 80)) /\ (BArray64.is_init b_v 0 64)) /\
      (BArray16.is_init b_m (8 * (t %% 2)) 8)) /\
     (BArray256.is_init b_x 0 256)))]);
    b_vs <- false;
    b_vw <- false;
    b_vu <- false;
    b_vt <- false;
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 1) %% 8) * 32)) /\
       (((((j + 1) %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      b_vs <- true;
      vs <-
      (VPALIGNR_256 (BArray256.get256 x ((j + 1) %% 8))
      (BArray256.get256 x (j %% 8)) (W8.of_int 8));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 5) %% 8) * 32)) /\
       (((((j + 5) %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 4) %% 8) * 32)) /\
       (((((j + 4) %% 8) * 32) + 32) <= 256)))]);
      b_vw <- true;
      vw <-
      (VPALIGNR_256 (BArray256.get256 x ((j + 5) %% 8))
      (BArray256.get256 x ((j + 4) %% 8)) (W8.of_int 8));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 7) %% 8) * 32)) /\
       (((((j + 7) %% 8) * 32) + 32) <= 256)))]);
      b_vu <- true;
      vu <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshr64u256 (W128.of_int 6));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 7) %% 8) * 32)) /\
       (((((j + 7) %% 8) * 32) + 32) <= 256)))]);
      b_vw <- true;
      vw <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshl64u256 (W128.of_int 3));
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    v <-
    (BArray64.set64 v ((80 - t) %% 8)
    ((BArray64.get64 v ((80 - t) %% 8)) + s));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((85 - t) %% 8) * 8)) /\ (((((85 - t) %% 8) * 8) + 8) <= 64)))]);
    y <- (BArray64.get64 v ((85 - t) %% 8));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((84 - t) %% 8) * 8)) /\ (((((84 - t) %% 8) * 8) + 8) <= 64)))]);
    y <- (y `&` (BArray64.get64 v ((84 - t) %% 8)));
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vw));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vs)]);
      b_vt <- true;
      vt <- (vs \vshr64u256 (W128.of_int 1));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert,
       ((0 <= (((j + 7) %% 8) * 32)) /\
       (((((j + 7) %% 8) * 32) + 32) <= 256)))]);
      b_vt <- true;
      vt <-
      ((BArray256.get256 x ((j + 7) %% 8)) \vshr64u256 (W128.of_int 19));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((84 - t) %% 8) * 8)) /\ (((((84 - t) %% 8) * 8) + 8) <= 64)))]);
    z <- (RORX_64 (BArray64.get64 v ((84 - t) %% 8)) (W8.of_int 41));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((84 - t) %% 8) * 8)) /\ (((((84 - t) %% 8) * 8) + 8) <= 64)))]);
    w <- (RORX_64 (BArray64.get64 v ((84 - t) %% 8)) (W8.of_int 18));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    v <-
    (BArray64.set64 v ((87 - t) %% 8)
    ((BArray64.get64 v ((87 - t) %% 8)) + y));
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vs)]);
      b_vu <- true;
      vu <- (vs \vshr64u256 (W128.of_int 7));
      b_vw <- true;
      vw <- (vs \vshl64u256 (W128.of_int 56));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      b_vw <- true;
      vw <- (vw \vshl64u256 (W128.of_int 42));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vt)]);
      b_vu <- true;
      vu <- (vu `^` vt);
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((84 - t) %% 8) * 8)) /\ (((((84 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((86 - t) %% 8) * 8)) /\ (((((86 - t) %% 8) * 8) + 8) <= 64)))]);
    ( _0,  _1,  _2,  _3,  _4, y) <-
    (ANDN_64 (BArray64.get64 v ((84 - t) %% 8))
    (BArray64.get64 v ((86 - t) %% 8)));
    z <- (z `^` w);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((84 - t) %% 8) * 8)) /\ (((((84 - t) %% 8) * 8) + 8) <= 64)))]);
    w <- (RORX_64 (BArray64.get64 v ((84 - t) %% 8)) (W8.of_int 14));
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vt)]);
      b_vu <- true;
      vu <- (vu `^` vt);
      b_vt <- true;
      vt <- (vt \vshr64u256 (W128.of_int 7));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vt)]);
      b_vt <- true;
      vt <- (vt \vshr64u256 (W128.of_int 42));
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    v <-
    (BArray64.set64 v ((87 - t) %% 8)
    ((BArray64.get64 v ((87 - t) %% 8)) + y));
    z <- (z `^` w);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 8)) /\ (((((t + 1) %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    b_m <-
    (BArray16.set64d b_m (((t + 1) %% 2) * 8)
    (W64.of_int 18446744073709551615));
    m <-
    (BArray16.set64 m ((t + 1) %% 2) (BArray64.get64 v ((80 - t) %% 8)));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    y <- (RORX_64 (BArray64.get64 v ((80 - t) %% 8)) (W8.of_int 39));
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
      b_vw <- true;
      vw <- (vw \vshl64u256 (W128.of_int 7));
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vt)]);
      b_vu <- true;
      vu <- (vu `^` vt);
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    v <-
    (BArray64.set64 v ((87 - t) %% 8)
    ((BArray64.get64 v ((87 - t) %% 8)) + z));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 8)) /\ (((((t + 1) %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 8)) /\ (((((t + 1) %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, (BArray16.is_init b_m (((t + 1) %% 2) * 8) 8))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((81 - t) %% 8) * 8)) /\ (((((81 - t) %% 8) * 8) + 8) <= 64)))]);
    b_m <-
    (BArray16.set64d b_m (((t + 1) %% 2) * 8)
    (W64.of_int 18446744073709551615));
    m <-
    (BArray16.set64 m ((t + 1) %% 2)
    ((BArray16.get64 m ((t + 1) %% 2)) `^`
    (BArray64.get64 v ((81 - t) %% 8))));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    s <- (RORX_64 (BArray64.get64 v ((80 - t) %% 8)) (W8.of_int 34));
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vt)]);
      vu <- (vu `^` vt);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vw)]);
      b_vu <- true;
      vu <- (vu `^` vw);
    } else {
      
    }
    if ((ph = 1)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vu));
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((80 - t) %% 8) * 8)) /\ (((((80 - t) %% 8) * 8) + 8) <= 64)))]);
    z <- (RORX_64 (BArray64.get64 v ((80 - t) %% 8)) (W8.of_int 28));
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((83 - t) %% 8) * 8)) /\ (((((83 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((83 - t) %% 8) * 8)) /\ (((((83 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    v <-
    (BArray64.set64 v ((83 - t) %% 8)
    ((BArray64.get64 v ((83 - t) %% 8)) + (BArray64.get64 v ((87 - t) %% 8)))
    );
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 8)) /\ ((((t %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 8)) /\ ((((t %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, (BArray16.is_init b_m ((t %% 2) * 8) 8))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((t + 1) %% 2) * 8)) /\ (((((t + 1) %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, (BArray16.is_init b_m (((t + 1) %% 2) * 8) 8))]);
    b_m <-
    (BArray16.set64d b_m ((t %% 2) * 8) (W64.of_int 18446744073709551615));
    m <-
    (BArray16.set64 m (t %% 2)
    ((BArray16.get64 m (t %% 2)) `&` (BArray16.get64 m ((t + 1) %% 2))));
    s <- (s `^` y);
    if ((ph = 0)) {
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++
      [(Assert, ((0 <= ((j %% 8) * 32)) /\ ((((j %% 8) * 32) + 32) <= 256)))]);
      trace___sha512_avx2_round <-
      (trace___sha512_avx2_round ++ [(Assert, b_vu)]);
      x <-
      (BArray256.set256 x (j %% 8)
      ((BArray256.get256 x (j %% 8)) \vadd64u256 vu));
    } else {
      
    }
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 8)) /\ ((((t %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 8)) /\ ((((t %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, (BArray16.is_init b_m ((t %% 2) * 8) 8))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((81 - t) %% 8) * 8)) /\ (((((81 - t) %% 8) * 8) + 8) <= 64)))]);
    b_m <-
    (BArray16.set64d b_m ((t %% 2) * 8) (W64.of_int 18446744073709551615));
    m <-
    (BArray16.set64 m (t %% 2)
    ((BArray16.get64 m (t %% 2)) `^` (BArray64.get64 v ((81 - t) %% 8))));
    s <- (s `^` z);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert,
     ((0 <= (((87 - t) %% 8) * 8)) /\ (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, ((0 <= ((t %% 2) * 8)) /\ ((((t %% 2) * 8) + 8) <= 16)))]);
    trace___sha512_avx2_round <-
    (trace___sha512_avx2_round ++
    [(Assert, (BArray16.is_init b_m ((t %% 2) * 8) 8))]);
    v <-
    (BArray64.set64 v ((87 - t) %% 8)
    ((BArray64.get64 v ((87 - t) %% 8)) + (BArray16.get64 m (t %% 2))));
    b_v <- (BArray64.init_arr (W8.of_int 255));
    b_x <- (BArray256.init_arr (W8.of_int 255));
    return (v, b_v, m, b_m, s, x, b_x, trace___sha512_avx2_round);
  }
  proc __sha512_avx2 (h:BArray64.t, b_h:BArray64.t, x:BArray256.t,
                      b_x:BArray256.t, nb:int, ms:W64.t) : BArray64.t *
                                                           BArray64.t *
                                                           W64.t * trace = {
    var aux_1:BArray16.t;
    var aux_2:BArray16.t;
    var aux_4:BArray256.t;
    var aux_5:BArray256.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:W64.t;
    var inc:int;
    var i:int;
    var k:W256.t;
    var wk:BArray1280.t;
    var v:BArray64.t;
    var m:BArray16.t;
    var s:W64.t;
    var t:int;
    var l:int;
    var param:int;
    var param_0:int;
    var param_1:BArray256.t;
    var param_2:int;
    var param_3:W64.t;
    var param_4:BArray16.t;
    var param_5:BArray64.t;
    var result:BArray256.t;
    var result_0:W64.t;
    var result_1:BArray16.t;
    var result_2:BArray64.t;
    var param_6:int;
    var param_7:int;
    var param_8:BArray256.t;
    var param_9:int;
    var param_10:W64.t;
    var param_11:BArray16.t;
    var param_12:BArray64.t;
    var result_3:BArray256.t;
    var result_4:W64.t;
    var result_5:BArray16.t;
    var result_6:BArray64.t;
    var b_v:BArray64.t;
    var b_wk:BArray1280.t;
    var b_result:BArray256.t;
    var b_m:BArray16.t;
    var b_result_0:BArray16.t;
    var b_result_1:BArray64.t;
    var b_param:BArray16.t;
    var b_param_0:BArray64.t;
    var b_result_2:BArray256.t;
    var b_result_3:BArray16.t;
    var b_result_4:BArray64.t;
    var b_param_1:BArray16.t;
    var b_param_2:BArray64.t;
    var trace___sha512_avx2:trace;
    b_m <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    b_result_4 <- witness;
    b_v <- witness;
    b_wk <- witness;
    m <- witness;
    param_1 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_8 <- witness;
    param_11 <- witness;
    param_12 <- witness;
    result <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    v <- witness;
    wk <- witness;
    trace___sha512_avx2 <- [];
    trace___sha512_avx2 <-
    (trace___sha512_avx2 ++
    [(Assert,
     ((((0 <= nb) /\ (nb <= 2)) /\ (BArray64.is_init b_h 0 64)) /\
     (BArray256.is_init b_x 0 256)))]);
    b_m <- (BArray16.init_arr (W8.of_int 0));
    b_v <- (BArray64.init_arr (W8.of_int 0));
    b_wk <- (BArray1280.init_arr (W8.of_int 0));
    i <- 0;
    while ((i < 8)) {
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++
      [(Assert, ((0 <= (i * 16)) /\ (((i * 16) + 16) <= 640)))]);
      k <- (VPBROADCAST_2u128 (BArray640.get128 sHA512_K i));
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      k <- (k \vadd64u256 (BArray256.get256 x i));
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 1280)))]);
      b_wk <-
      (BArray1280.set256d b_wk (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      wk <- (BArray1280.set256 wk i k);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 8)) {
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_v <- (BArray64.set64d b_v (i * 8) (W64.of_int 18446744073709551615));
      v <- (BArray64.set64 v i (BArray64.get64 h i));
      i <- (i + 1);
    }
    inc <- nb;
    l <- 0;
    while ((l < inc)) {
      (* Erased call to spill *)
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++ [(Assert, (BArray64.is_init b_v 8 8))]);
      b_m <- (BArray16.set64d b_m 0 (W64.of_int 18446744073709551615));
      m <- (BArray16.set64 m 0 (BArray64.get64 v 1));
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++ [(Assert, (BArray16.is_init b_m 0 8))]);
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++ [(Assert, (BArray64.is_init b_v 16 8))]);
      b_m <- (BArray16.set64d b_m 0 (W64.of_int 18446744073709551615));
      m <-
      (BArray16.set64 m 0 ((BArray16.get64 m 0) `^` (BArray64.get64 v 2)));
      s <- (W64.of_int 0);
      t <- 0;
      while ((t < 80)) {
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert,
         ((0 <= (((87 - t) %% 8) * 8)) /\
         (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert,
         ((0 <= (((87 - t) %% 8) * 8)) /\
         (((((87 - t) %% 8) * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, (BArray64.is_init b_v (((87 - t) %% 8) * 8) 8))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert,
         ((0 <= ((((4 * (t %/ 2)) + (2 * l)) + (t %% 2)) * 8)) /\
         ((((((4 * (t %/ 2)) + (2 * l)) + (t %% 2)) * 8) + 8) <= 1280)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert,
         (BArray1280.is_init b_wk
         ((((4 * (t %/ 2)) + (2 * l)) + (t %% 2)) * 8) 8))]);
        b_v <-
        (BArray64.set64d b_v (((87 - t) %% 8) * 8)
        (W64.of_int 18446744073709551615));
        v <-
        (BArray64.set64 v ((87 - t) %% 8)
        ((BArray64.get64 v ((87 - t) %% 8)) +
        (BArray1280.get64 wk (((4 * (t %/ 2)) + (2 * l)) + (t %% 2)))));
        if (((l = 0) /\ (t < 64))) {
          b_param_0 <- b_v;
          param_5 <- v;
          b_param <- b_m;
          param_4 <- m;
          param_3 <- s;
          param_2 <- t;
          param_1 <- x;
          param_0 <- (t %/ 2);
          param <- (t %% 2);
          (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ 
          __sha512_avx2_round (param_5, b_param_0, param_4, b_param, 
          param_3, param_2, param_1, (BArray256.init_arr (W8.of_int 255)),
          param_0, param);
          result_2 <- aux;
          b_result_1 <- aux_0;
          result_1 <- aux_1;
          b_result_0 <- aux_2;
          result_0 <- aux_3;
          result <- aux_4;
          b_result <- aux_5;
          trace___sha512_avx2 <- (trace___sha512_avx2 ++ tmp__trace);
          trace___sha512_avx2 <-
          (trace___sha512_avx2 ++
          [(Assert,
           (((BArray64.is_init b_result_1 0 64) /\
            (BArray16.is_init b_result_0 0 16)) /\
           (BArray256.is_init b_result 0 256)))]);
          b_v <- (BArray64.init_arr (W8.of_int 255));
          v <- result_2;
          b_m <- (BArray16.init_arr (W8.of_int 255));
          m <- result_1;
          s <- result_0;
          x <- result;
        } else {
          b_param_2 <- b_v;
          param_12 <- v;
          b_param_1 <- b_m;
          param_11 <- m;
          param_10 <- s;
          param_9 <- t;
          param_8 <- x;
          param_7 <- 0;
          param_6 <- 2;
          (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ 
          __sha512_avx2_round (param_12, b_param_2, param_11, b_param_1,
          param_10, param_9, param_8, (BArray256.init_arr (W8.of_int 255)),
          param_7, param_6);
          result_6 <- aux;
          b_result_4 <- aux_0;
          result_5 <- aux_1;
          b_result_3 <- aux_2;
          result_4 <- aux_3;
          result_3 <- aux_4;
          b_result_2 <- aux_5;
          trace___sha512_avx2 <- (trace___sha512_avx2 ++ tmp__trace);
          trace___sha512_avx2 <-
          (trace___sha512_avx2 ++
          [(Assert,
           (((BArray64.is_init b_result_4 0 64) /\
            (BArray16.is_init b_result_3 0 16)) /\
           (BArray256.is_init b_result_2 0 256)))]);
          b_v <- (BArray64.init_arr (W8.of_int 255));
          v <- result_6;
          b_m <- (BArray16.init_arr (W8.of_int 255));
          m <- result_5;
          s <- result_4;
          x <- result_3;
        }
        if ((((l = 0) /\ (t < 64)) /\ ((t %% 2) = 1))) {
          trace___sha512_avx2 <-
          (trace___sha512_avx2 ++
          [(Assert,
           ((0 <= ((8 + (t %/ 2)) * 16)) /\
           ((((8 + (t %/ 2)) * 16) + 16) <= 640)))]);
          k <-
          (VPBROADCAST_2u128 (BArray640.get128 sHA512_K (8 + (t %/ 2))));
          trace___sha512_avx2 <-
          (trace___sha512_avx2 ++
          [(Assert,
           ((0 <= (((t %/ 2) %% 8) * 32)) /\
           (((((t %/ 2) %% 8) * 32) + 32) <= 256)))]);
          k <- (k \vadd64u256 (BArray256.get256 x ((t %/ 2) %% 8)));
          trace___sha512_avx2 <-
          (trace___sha512_avx2 ++
          [(Assert,
           ((0 <= ((8 + (t %/ 2)) * 32)) /\
           ((((8 + (t %/ 2)) * 32) + 32) <= 1280)))]);
          b_wk <-
          (BArray1280.set256d b_wk ((8 + (t %/ 2)) * 32)
          (W256.of_int
          115792089237316195423570985008687907853269984665640564039457584007913129639935
          ));
          wk <- (BArray1280.set256 wk (8 + (t %/ 2)) k);
        } else {
          
        }
        t <- (t + 1);
      }
      trace___sha512_avx2 <-
      (trace___sha512_avx2 ++ [(Assert, (BArray64.is_init b_v 0 8))]);
      b_v <- (BArray64.set64d b_v 0 (W64.of_int 18446744073709551615));
      v <- (BArray64.set64 v 0 ((BArray64.get64 v 0) + s));
      (* Erased call to unspill *)
      h <- (protect_ptr h ms);
      i <- 0;
      while ((i < 8)) {
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++ [(Assert, (BArray64.is_init b_v (i * 8) 8))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        b_v <-
        (BArray64.set64d b_v (i * 8) (W64.of_int 18446744073709551615));
        v <-
        (BArray64.set64 v i ((BArray64.get64 v i) + (BArray64.get64 h i)));
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        trace___sha512_avx2 <-
        (trace___sha512_avx2 ++ [(Assert, (BArray64.is_init b_v (i * 8) 8))]);
        h <- (BArray64.set64 h i (BArray64.get64 v i));
        i <- (i + 1);
      }
      l <- (l + 1);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace___sha512_avx2);
  }
  proc _sha512_compress (h:BArray64.t, b_h:BArray64.t, block:BArray128.t,
                         b_block:BArray128.t, ms:W64.t) : BArray64.t *
                                                          BArray64.t *
                                                          W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray256.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray256.t;
    var b_x:BArray256.t;
    var trace__sha512_compress:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha512_compress <- [];
    trace__sha512_compress <-
    (trace__sha512_compress ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\ (BArray128.is_init b_block 0 128)))]);
    b_x <- (BArray256.init_arr (W8.of_int 0));
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      trace__sha512_compress <-
      (trace__sha512_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress <-
      (trace__sha512_compress ++
      [(Assert, ((0 <= (i * 16)) /\ (((i * 16) + 16) <= 128)))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray256.set256 x i (VPBROADCAST_2u128 (BArray128.get128 block i)));
      trace__sha512_compress <-
      (trace__sha512_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress <-
      (trace__sha512_compress ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress <-
      (trace__sha512_compress ++
      [(Assert, (BArray256.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 1;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha512_avx2 (param_2,
    (BArray64.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha512_compress <- (trace__sha512_compress ++ tmp__trace);
    trace__sha512_compress <-
    (trace__sha512_compress ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha512_compress);
  }
  proc _sha512_compress_one (h:BArray64.t, b_h:BArray64.t, p:W64.t, ms:W64.t) : 
  BArray64.t * BArray64.t * W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray256.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray256.t;
    var b_x:BArray256.t;
    var trace__sha512_compress_one:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha512_compress_one <- [];
    trace__sha512_compress_one <-
    (trace__sha512_compress_one ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 128)))]);
    b_x <- (BArray256.init_arr (W8.of_int 0));
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      trace__sha512_compress_one <-
      (trace__sha512_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_one <-
      (trace__sha512_compress_one ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint (p + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray256.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      trace__sha512_compress_one <-
      (trace__sha512_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_one <-
      (trace__sha512_compress_one ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_one <-
      (trace__sha512_compress_one ++
      [(Assert, (BArray256.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 1;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha512_avx2 (param_2,
    (BArray64.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha512_compress_one <- (trace__sha512_compress_one ++ tmp__trace);
    trace__sha512_compress_one <-
    (trace__sha512_compress_one ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha512_compress_one);
  }
  proc _sha512_compress_two (h:BArray64.t, b_h:BArray64.t, p:W64.t, ms:W64.t) : 
  BArray64.t * BArray64.t * W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var mask_p:BArray32.t;
    var mask:W256.t;
    var i:int;
    var x:BArray256.t;
    var param:W64.t;
    var param_0:int;
    var param_1:BArray256.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray256.t;
    var b_x:BArray256.t;
    var trace__sha512_compress_two:trace;
    b_param <- witness;
    b_result <- witness;
    b_x <- witness;
    mask_p <- witness;
    param_1 <- witness;
    param_2 <- witness;
    result_0 <- witness;
    x <- witness;
    trace__sha512_compress_two <- [];
    trace__sha512_compress_two <-
    (trace__sha512_compress_two ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 256)))]);
    b_x <- (BArray256.init_arr (W8.of_int 0));
    mask_p <- sHA512_AVX2_BSWAP;
    mask <- (BArray32.get256 mask_p 0);
    i <- 0;
    while ((i < 8)) {
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint (p + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray256.set256 x i
      (VPBROADCAST_2u128
      (loadW128 Glob.mem (W64.to_uint (p + (W64.of_int (16 * i)))))));
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, (BArray256.is_init b_x (i * 32) 32))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert,
       (is_valid ptr_modulus Glob.mem_v
       (W64.to_uint ((p + (W64.of_int 128)) + (W64.of_int (16 * i)))) 16))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <-
      (BArray256.set256 x i
      (VINSERTI128 (BArray256.get256 x i)
      (loadW128 Glob.mem
      (W64.to_uint ((p + (W64.of_int 128)) + (W64.of_int (16 * i)))))
      (W8.of_int 1)));
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, ((0 <= (i * 32)) /\ (((i * 32) + 32) <= 256)))]);
      trace__sha512_compress_two <-
      (trace__sha512_compress_two ++
      [(Assert, (BArray256.is_init b_x (i * 32) 32))]);
      b_x <-
      (BArray256.set256d b_x (i * 32)
      (W256.of_int
      115792089237316195423570985008687907853269984665640564039457584007913129639935
      ));
      x <- (BArray256.set256 x i (VPSHUFB_256 (BArray256.get256 x i) mask));
      i <- (i + 1);
    }
    param_2 <- h;
    b_param <- b_x;
    param_1 <- x;
    param_0 <- 2;
    param <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ __sha512_avx2 (param_2,
    (BArray64.init_arr (W8.of_int 255)), param_1, b_param, param_0, param);
    result_0 <- aux;
    b_result <- aux_0;
    result <- aux_1;
    trace__sha512_compress_two <- (trace__sha512_compress_two ++ tmp__trace);
    trace__sha512_compress_two <-
    (trace__sha512_compress_two ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_0;
    ms <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha512_compress_two);
  }
  proc _sha512_compress_blocks (h:BArray64.t, b_h:BArray64.t, p:W64.t,
                                n:W64.t, ms:W64.t) : BArray64.t *
                                                     BArray64.t * W64.t *
                                                     trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var more:bool;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var b_result:BArray64.t;
    var b_result_0:BArray64.t;
    var trace__sha512_compress_blocks:trace;
    b_result <- witness;
    b_result_0 <- witness;
    param_1 <- witness;
    param_4 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    trace__sha512_compress_blocks <- [];
    trace__sha512_compress_blocks <-
    (trace__sha512_compress_blocks ++
    [(Assert,
     (((BArray64.is_init b_h 0 64) /\
      (n \ult (W64.of_int 144115188075855872))) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint p)
     (W64.to_uint ((W64.of_int 128) * n)))))]);
    more <- ((W64.of_int 2) \ule n);
    while (more) {
      ms <- (update_msf more ms);
      (* Erased call to spill *)
      param_1 <- h;
      param_0 <- p;
      param <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress_two (param_1,
      (BArray64.init_arr (W8.of_int 255)), param_0, param);
      result_0 <- aux;
      b_result_0 <- aux_0;
      result <- aux_1;
      trace__sha512_compress_blocks <-
      (trace__sha512_compress_blocks ++ tmp__trace);
      trace__sha512_compress_blocks <-
      (trace__sha512_compress_blocks ++
      [(Assert, (BArray64.is_init b_result_0 0 64))]);
      h <- result_0;
      ms <- result;
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
      param_4 <- h;
      param_3 <- p;
      param_2 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress_one (param_4,
      (BArray64.init_arr (W8.of_int 255)), param_3, param_2);
      result_2 <- aux;
      b_result <- aux_0;
      result_1 <- aux_1;
      trace__sha512_compress_blocks <-
      (trace__sha512_compress_blocks ++ tmp__trace);
      trace__sha512_compress_blocks <-
      (trace__sha512_compress_blocks ++
      [(Assert, (BArray64.is_init b_result 0 64))]);
      h <- result_2;
      ms <- result_1;
    } else {
      ms <- (update_msf (! more) ms);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, ms, trace__sha512_compress_blocks);
  }
  proc __sha512_load_iv (h:BArray64.t, b_h:BArray64.t, iv:BArray64.t,
                         b_iv:BArray64.t) : BArray64.t * BArray64.t * trace = {
    var i:int;
    var t:W64.t;
    var trace___sha512_load_iv:trace;
    trace___sha512_load_iv <- [];
    trace___sha512_load_iv <-
    (trace___sha512_load_iv ++ [(Assert, (BArray64.is_init b_iv 0 64))]);
    i <- 0;
    while ((i < 8)) {
      trace___sha512_load_iv <-
      (trace___sha512_load_iv ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 iv i);
      trace___sha512_load_iv <-
      (trace___sha512_load_iv ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_h <- (BArray64.set64d b_h (i * 8) (W64.of_int 18446744073709551615));
      h <- (BArray64.set64 h i t);
      i <- (i + 1);
    }
    return (h, b_h, trace___sha512_load_iv);
  }
  proc __sha512_init (h:BArray64.t, b_h:BArray64.t) : BArray64.t *
                                                      BArray64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var param:BArray64.t;
    var param_0:BArray64.t;
    var result:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var trace___sha512_init:trace;
    b_param <- witness;
    b_result <- witness;
    param <- witness;
    param_0 <- witness;
    result <- witness;
    trace___sha512_init <- [];
    b_param <- b_h;
    param_0 <- h;
    param <- sHA512_IV;
    (aux, aux_0, tmp__trace) <@ __sha512_load_iv (param_0, b_param, param,
    (BArray64.init_arr (W8.of_int 255)));
    result <- aux;
    b_result <- aux_0;
    trace___sha512_init <- (trace___sha512_init ++ tmp__trace);
    trace___sha512_init <-
    (trace___sha512_init ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, trace___sha512_init);
  }
  proc __sha384_init (h:BArray64.t, b_h:BArray64.t) : BArray64.t *
                                                      BArray64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var param:BArray64.t;
    var param_0:BArray64.t;
    var result:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var trace___sha384_init:trace;
    b_param <- witness;
    b_result <- witness;
    param <- witness;
    param_0 <- witness;
    result <- witness;
    trace___sha384_init <- [];
    b_param <- b_h;
    param_0 <- h;
    param <- sHA384_IV;
    (aux, aux_0, tmp__trace) <@ __sha512_load_iv (param_0, b_param, param,
    (BArray64.init_arr (W8.of_int 255)));
    result <- aux;
    b_result <- aux_0;
    trace___sha384_init <- (trace___sha384_init ++ tmp__trace);
    trace___sha384_init <-
    (trace___sha384_init ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, trace___sha384_init);
  }
  proc __sha512_224_init (h:BArray64.t, b_h:BArray64.t) : BArray64.t *
                                                          BArray64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var param:BArray64.t;
    var param_0:BArray64.t;
    var result:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var trace___sha512_224_init:trace;
    b_param <- witness;
    b_result <- witness;
    param <- witness;
    param_0 <- witness;
    result <- witness;
    trace___sha512_224_init <- [];
    b_param <- b_h;
    param_0 <- h;
    param <- sHA512_224_IV;
    (aux, aux_0, tmp__trace) <@ __sha512_load_iv (param_0, b_param, param,
    (BArray64.init_arr (W8.of_int 255)));
    result <- aux;
    b_result <- aux_0;
    trace___sha512_224_init <- (trace___sha512_224_init ++ tmp__trace);
    trace___sha512_224_init <-
    (trace___sha512_224_init ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, trace___sha512_224_init);
  }
  proc __sha512_256_init (h:BArray64.t, b_h:BArray64.t) : BArray64.t *
                                                          BArray64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var param:BArray64.t;
    var param_0:BArray64.t;
    var result:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var trace___sha512_256_init:trace;
    b_param <- witness;
    b_result <- witness;
    param <- witness;
    param_0 <- witness;
    result <- witness;
    trace___sha512_256_init <- [];
    b_param <- b_h;
    param_0 <- h;
    param <- sHA512_256_IV;
    (aux, aux_0, tmp__trace) <@ __sha512_load_iv (param_0, b_param, param,
    (BArray64.init_arr (W8.of_int 255)));
    result <- aux;
    b_result <- aux_0;
    trace___sha512_256_init <- (trace___sha512_256_init ++ tmp__trace);
    trace___sha512_256_init <-
    (trace___sha512_256_init ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, trace___sha512_256_init);
  }
  proc _sha512_absorb_mem (h:BArray64.t, b_h:BArray64.t, buf:BArray128.t,
                           b_buf:BArray128.t, total:W64.t, in_0:W64.t,
                           inlen:W64.t, ms:W64.t) : BArray64.t * BArray64.t *
                                                    BArray128.t *
                                                    BArray128.t * W64.t *
                                                    W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var n:W64.t;
    var full:bool;
    var off:W64.t;
    var more:bool;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_4:W64.t;
    var param_5:BArray128.t;
    var param_6:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var param_11:W64.t;
    var param_12:W64.t;
    var param_13:W64.t;
    var param_14:W64.t;
    var param_15:BArray128.t;
    var result_5:W64.t;
    var result_6:BArray128.t;
    var b_result:BArray128.t;
    var b_param:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param_0:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_1:BArray128.t;
    var trace__sha512_absorb_mem:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_3 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_10 <- witness;
    param_15 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_6 <- witness;
    trace__sha512_absorb_mem <- [];
    trace__sha512_absorb_mem <-
    (trace__sha512_absorb_mem ++
    [(Assert,
     (((BArray64.is_init b_h 0 64) /\
      (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128)))
      )) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    total <- (total + inlen);
    n <- (W64.of_int 128);
    n <- (n - fill);
    n <- ((inlen \ult n) ? inlen : n);
    n <- ((fill = (W64.of_int 0)) ? fill : n);
    inlen <- (inlen - n);
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- fill;
    param_1 <- in_0;
    param_0 <- n;
    param <- ms;
    (result_0, b_result_2, result, tmp__trace) <@ __fill128_mem (param_3,
    b_param_1, param_2, param_1, param_0, param);
    trace__sha512_absorb_mem <- (trace__sha512_absorb_mem ++ tmp__trace);
    trace__sha512_absorb_mem <-
    (trace__sha512_absorb_mem ++
    [(Assert,
     (BArray128.is_init b_result_2 0 (W64.to_uint (param_2 + param_0))))]);
    b_buf <- b_result_2;
    buf <- result_0;
    ms <- result;
    fill <- (fill + n);
    in_0 <- (in_0 + n);
    full <- (fill = (W64.of_int 128));
    if (full) {
      ms <- (update_msf full ms);
      (* Erased call to spill *)
      param_6 <- h;
      b_param_0 <- b_buf;
      param_5 <- buf;
      param_4 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_6,
      (BArray64.init_arr (W8.of_int 255)), param_5, b_param_0, param_4);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha512_absorb_mem <- (trace__sha512_absorb_mem ++ tmp__trace);
      trace__sha512_absorb_mem <-
      (trace__sha512_absorb_mem ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      b_buf <- b_buf;
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
      param_10 <- h;
      param_9 <- in_0;
      param_8 <- n;
      param_7 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress_blocks (param_10,
      (BArray64.init_arr (W8.of_int 255)), param_9, param_8, param_7);
      result_4 <- aux;
      b_result_0 <- aux_0;
      result_3 <- aux_1;
      trace__sha512_absorb_mem <- (trace__sha512_absorb_mem ++ tmp__trace);
      trace__sha512_absorb_mem <-
      (trace__sha512_absorb_mem ++
      [(Assert, (BArray64.is_init b_result_0 0 64))]);
      h <- result_4;
      ms <- result_3;
      (* Erased call to unspill *)
      total <- (protect_64 total ms);
      in_0 <- (protect_64 in_0 ms);
      inlen <- (protect_64 inlen ms);
      b_buf <- b_buf;
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
    b_param <- b_buf;
    param_15 <- buf;
    param_14 <- fill;
    param_13 <- in_0;
    param_12 <- inlen;
    param_11 <- ms;
    (result_6, b_result, result_5, tmp__trace) <@ __fill128_mem (param_15,
    b_param, param_14, param_13, param_12, param_11);
    trace__sha512_absorb_mem <- (trace__sha512_absorb_mem ++ tmp__trace);
    trace__sha512_absorb_mem <-
    (trace__sha512_absorb_mem ++
    [(Assert,
     (BArray128.is_init b_result 0 (W64.to_uint (param_14 + param_12))))]);
    b_buf <- b_result;
    buf <- result_6;
    ms <- result_5;
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (h, b_h, buf, b_buf, total, ms, trace__sha512_absorb_mem);
  }
  proc _sha512___sha512_finalize (out:BArray64.t, b_out:BArray64.t,
                                  h:BArray64.t, b_h:BArray64.t,
                                  buf:BArray128.t, b_buf:BArray128.t,
                                  total:W64.t, ms:W64.t) : BArray64.t *
                                                           BArray64.t *
                                                           BArray64.t *
                                                           BArray64.t *
                                                           BArray128.t *
                                                           BArray128.t *
                                                           W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray128.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var result_6:W64.t;
    var param_12:W64.t;
    var param_13:BArray128.t;
    var param_14:BArray64.t;
    var result_7:W64.t;
    var result_8:BArray64.t;
    var param_15:W64.t;
    var result_9:W64.t;
    var param_16:W32.t;
    var result_10:W32.t;
    var b_result:BArray64.t;
    var b_param:BArray128.t;
    var b_result_0:BArray128.t;
    var b_param_0:BArray128.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_2:BArray128.t;
    var trace__sha512___sha512_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_13 <- witness;
    param_14 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_8 <- witness;
    trace__sha512___sha512_finalize <- [];
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 128)))]);
    b_buf <- (BArray128.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero128 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++ tmp__trace);
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, (BArray128.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_5,
      (BArray64.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++ tmp__trace);
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero128 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++ tmp__trace);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++
    [(Assert, (BArray128.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray128.set64d b_buf 112 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_11 <- t;
    (result_6, tmp__trace) <@ __bswap64 (param_11);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++ tmp__trace);
    t <- result_6;
    b_buf <- (BArray128.set64d b_buf 120 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    param_14 <- h;
    b_param <- b_buf;
    param_13 <- buf;
    param_12 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_14,
    (BArray64.init_arr (W8.of_int 255)), param_13, b_param, param_12);
    result_8 <- aux;
    b_result <- aux_0;
    result_7 <- aux_1;
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++ tmp__trace);
    trace__sha512___sha512_finalize <-
    (trace__sha512___sha512_finalize ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_8;
    ms <- result_7;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 8)) {
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      param_15 <- x;
      (result_9, tmp__trace) <@ __bswap64 (param_15);
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++ tmp__trace);
      x <- result_9;
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_out <-
      (BArray64.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
      out <- (BArray64.set64 out i x);
      i <- (i + 1);
    }
    i <- 8;
    while ((i < 8)) {
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      param_16 <- y;
      (result_10, tmp__trace) <@ __bswap32 (param_16);
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++ tmp__trace);
      y <- result_10;
      trace__sha512___sha512_finalize <-
      (trace__sha512___sha512_finalize ++
      [(Assert, ((0 <= ((2 * i) * 4)) /\ ((((2 * i) * 4) + 4) <= 64)))]);
      b_out <- (BArray64.set32d b_out ((2 * i) * 4) (W32.of_int 4294967295));
      out <- (BArray64.set32 out (2 * i) y);
      i <- (i + 1);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha512___sha512_finalize);
  }
  proc _sha512____sha512_mem_from (out:BArray64.t, b_out:BArray64.t,
                                   h:BArray64.t, b_h:BArray64.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray64.t *
                                                            BArray64.t *
                                                            W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_5:BArray64.t;
    var aux_6:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray128.t;
    var param_4:BArray64.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray128.t;
    var result_2:BArray64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray128.t;
    var param_8:BArray64.t;
    var param_9:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var result_6:BArray64.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var b_buf_s:BArray128.t;
    var trace__sha512____sha512_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha512____sha512_mem_from <- [];
    trace__sha512____sha512_mem_from <-
    (trace__sha512____sha512_mem_from ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray128.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha512_absorb_mem (
    param_4, (BArray64.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha512____sha512_mem_from <-
    (trace__sha512____sha512_mem_from ++ tmp__trace);
    trace__sha512____sha512_mem_from <-
    (trace__sha512____sha512_mem_from ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 128))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux, aux_0, aux_5, aux_6, aux_1, aux_2, aux_3, tmp__trace) <@ _sha512___sha512_finalize (
    param_9, b_param_0, param_8, (BArray64.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux;
    b_result_1 <- aux_0;
    result_5 <- aux_5;
    b_result_0 <- aux_6;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha512____sha512_mem_from <-
    (trace__sha512____sha512_mem_from ++ tmp__trace);
    trace__sha512____sha512_mem_from <-
    (trace__sha512____sha512_mem_from ++
    [(Assert,
     (((BArray64.is_init b_result_1 0 64) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512____sha512_mem_from);
  }
  proc _sha384___sha512_finalize (out:BArray48.t, b_out:BArray48.t,
                                  h:BArray64.t, b_h:BArray64.t,
                                  buf:BArray128.t, b_buf:BArray128.t,
                                  total:W64.t, ms:W64.t) : BArray48.t *
                                                           BArray48.t *
                                                           BArray64.t *
                                                           BArray64.t *
                                                           BArray128.t *
                                                           BArray128.t *
                                                           W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray128.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var result_6:W64.t;
    var param_12:W64.t;
    var param_13:BArray128.t;
    var param_14:BArray64.t;
    var result_7:W64.t;
    var result_8:BArray64.t;
    var param_15:W64.t;
    var result_9:W64.t;
    var param_16:W32.t;
    var result_10:W32.t;
    var b_result:BArray64.t;
    var b_param:BArray128.t;
    var b_result_0:BArray128.t;
    var b_param_0:BArray128.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_2:BArray128.t;
    var trace__sha384___sha512_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_13 <- witness;
    param_14 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_8 <- witness;
    trace__sha384___sha512_finalize <- [];
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 128)))]);
    b_buf <- (BArray128.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero128 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++ tmp__trace);
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, (BArray128.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_5,
      (BArray64.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++ tmp__trace);
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero128 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++ tmp__trace);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++
    [(Assert, (BArray128.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray128.set64d b_buf 112 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_11 <- t;
    (result_6, tmp__trace) <@ __bswap64 (param_11);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++ tmp__trace);
    t <- result_6;
    b_buf <- (BArray128.set64d b_buf 120 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    param_14 <- h;
    b_param <- b_buf;
    param_13 <- buf;
    param_12 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_14,
    (BArray64.init_arr (W8.of_int 255)), param_13, b_param, param_12);
    result_8 <- aux;
    b_result <- aux_0;
    result_7 <- aux_1;
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++ tmp__trace);
    trace__sha384___sha512_finalize <-
    (trace__sha384___sha512_finalize ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_8;
    ms <- result_7;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 6)) {
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      param_15 <- x;
      (result_9, tmp__trace) <@ __bswap64 (param_15);
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++ tmp__trace);
      x <- result_9;
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 48)))]);
      b_out <-
      (BArray48.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
      out <- (BArray48.set64 out i x);
      i <- (i + 1);
    }
    i <- 6;
    while ((i < 6)) {
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      param_16 <- y;
      (result_10, tmp__trace) <@ __bswap32 (param_16);
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++ tmp__trace);
      y <- result_10;
      trace__sha384___sha512_finalize <-
      (trace__sha384___sha512_finalize ++
      [(Assert, ((0 <= ((2 * i) * 4)) /\ ((((2 * i) * 4) + 4) <= 48)))]);
      b_out <- (BArray48.set32d b_out ((2 * i) * 4) (W32.of_int 4294967295));
      out <- (BArray48.set32 out (2 * i) y);
      i <- (i + 1);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha384___sha512_finalize);
  }
  proc _sha384____sha512_mem_from (out:BArray48.t, b_out:BArray48.t,
                                   h:BArray64.t, b_h:BArray64.t, in_0:W64.t,
                                   inlen:W64.t, ms:W64.t) : BArray48.t *
                                                            BArray48.t *
                                                            W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux_5:BArray48.t;
    var aux_6:BArray48.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray128.t;
    var param_4:BArray64.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray128.t;
    var result_2:BArray64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray128.t;
    var param_8:BArray64.t;
    var param_9:BArray48.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var result_6:BArray48.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray48.t;
    var b_param:BArray128.t;
    var b_param_0:BArray48.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var b_buf_s:BArray128.t;
    var trace__sha384____sha512_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha384____sha512_mem_from <- [];
    trace__sha384____sha512_mem_from <-
    (trace__sha384____sha512_mem_from ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray128.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha512_absorb_mem (
    param_4, (BArray64.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha384____sha512_mem_from <-
    (trace__sha384____sha512_mem_from ++ tmp__trace);
    trace__sha384____sha512_mem_from <-
    (trace__sha384____sha512_mem_from ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 128))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux_5, aux_6, aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ _sha384___sha512_finalize (
    param_9, b_param_0, param_8, (BArray64.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux_5;
    b_result_1 <- aux_6;
    result_5 <- aux;
    b_result_0 <- aux_0;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha384____sha512_mem_from <-
    (trace__sha384____sha512_mem_from ++ tmp__trace);
    trace__sha384____sha512_mem_from <-
    (trace__sha384____sha512_mem_from ++
    [(Assert,
     (((BArray48.is_init b_result_1 0 48) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray48.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha384____sha512_mem_from);
  }
  proc _sha512_224___sha512_finalize (out:BArray28.t, b_out:BArray28.t,
                                      h:BArray64.t, b_h:BArray64.t,
                                      buf:BArray128.t, b_buf:BArray128.t,
                                      total:W64.t, ms:W64.t) : BArray28.t *
                                                               BArray28.t *
                                                               BArray64.t *
                                                               BArray64.t *
                                                               BArray128.t *
                                                               BArray128.t *
                                                               W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray128.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var result_6:W64.t;
    var param_12:W64.t;
    var param_13:BArray128.t;
    var param_14:BArray64.t;
    var result_7:W64.t;
    var result_8:BArray64.t;
    var param_15:W64.t;
    var result_9:W64.t;
    var param_16:W32.t;
    var result_10:W32.t;
    var b_result:BArray64.t;
    var b_param:BArray128.t;
    var b_result_0:BArray128.t;
    var b_param_0:BArray128.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_2:BArray128.t;
    var trace__sha512_224___sha512_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_13 <- witness;
    param_14 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_8 <- witness;
    trace__sha512_224___sha512_finalize <- [];
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 128)))]);
    b_buf <- (BArray128.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero128 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++ tmp__trace);
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, (BArray128.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_5,
      (BArray64.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++ tmp__trace);
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero128 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++ tmp__trace);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++
    [(Assert, (BArray128.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray128.set64d b_buf 112 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_11 <- t;
    (result_6, tmp__trace) <@ __bswap64 (param_11);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++ tmp__trace);
    t <- result_6;
    b_buf <- (BArray128.set64d b_buf 120 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    param_14 <- h;
    b_param <- b_buf;
    param_13 <- buf;
    param_12 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_14,
    (BArray64.init_arr (W8.of_int 255)), param_13, b_param, param_12);
    result_8 <- aux;
    b_result <- aux_0;
    result_7 <- aux_1;
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++ tmp__trace);
    trace__sha512_224___sha512_finalize <-
    (trace__sha512_224___sha512_finalize ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_8;
    ms <- result_7;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 3)) {
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      param_15 <- x;
      (result_9, tmp__trace) <@ __bswap64 (param_15);
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++ tmp__trace);
      x <- result_9;
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 28)))]);
      b_out <-
      (BArray28.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
      out <- (BArray28.set64 out i x);
      i <- (i + 1);
    }
    i <- 3;
    while ((i < 4)) {
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      param_16 <- y;
      (result_10, tmp__trace) <@ __bswap32 (param_16);
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++ tmp__trace);
      y <- result_10;
      trace__sha512_224___sha512_finalize <-
      (trace__sha512_224___sha512_finalize ++
      [(Assert, ((0 <= ((2 * i) * 4)) /\ ((((2 * i) * 4) + 4) <= 28)))]);
      b_out <- (BArray28.set32d b_out ((2 * i) * 4) (W32.of_int 4294967295));
      out <- (BArray28.set32 out (2 * i) y);
      i <- (i + 1);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha512_224___sha512_finalize);
  }
  proc _sha512_224____sha512_mem_from (out:BArray28.t, b_out:BArray28.t,
                                       h:BArray64.t, b_h:BArray64.t,
                                       in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray28.t * BArray28.t * W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux_5:BArray28.t;
    var aux_6:BArray28.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray128.t;
    var param_4:BArray64.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray128.t;
    var result_2:BArray64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray128.t;
    var param_8:BArray64.t;
    var param_9:BArray28.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var result_6:BArray28.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray28.t;
    var b_param:BArray128.t;
    var b_param_0:BArray28.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var b_buf_s:BArray128.t;
    var trace__sha512_224____sha512_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha512_224____sha512_mem_from <- [];
    trace__sha512_224____sha512_mem_from <-
    (trace__sha512_224____sha512_mem_from ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray128.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha512_absorb_mem (
    param_4, (BArray64.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha512_224____sha512_mem_from <-
    (trace__sha512_224____sha512_mem_from ++ tmp__trace);
    trace__sha512_224____sha512_mem_from <-
    (trace__sha512_224____sha512_mem_from ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 128))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux_5, aux_6, aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ _sha512_224___sha512_finalize (
    param_9, b_param_0, param_8, (BArray64.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux_5;
    b_result_1 <- aux_6;
    result_5 <- aux;
    b_result_0 <- aux_0;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha512_224____sha512_mem_from <-
    (trace__sha512_224____sha512_mem_from ++ tmp__trace);
    trace__sha512_224____sha512_mem_from <-
    (trace__sha512_224____sha512_mem_from ++
    [(Assert,
     (((BArray28.is_init b_result_1 0 28) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray28.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512_224____sha512_mem_from);
  }
  proc _sha512_256___sha512_finalize (out:BArray32.t, b_out:BArray32.t,
                                      h:BArray64.t, b_h:BArray64.t,
                                      buf:BArray128.t, b_buf:BArray128.t,
                                      total:W64.t, ms:W64.t) : BArray32.t *
                                                               BArray32.t *
                                                               BArray64.t *
                                                               BArray64.t *
                                                               BArray128.t *
                                                               BArray128.t *
                                                               W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var fill:W64.t;
    var t:W64.t;
    var two_blocks:bool;
    var hi:W64.t;
    var i:int;
    var x:W64.t;
    var y:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_6:W64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:BArray128.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var param_10:W64.t;
    var result_5:W64.t;
    var param_11:W64.t;
    var result_6:W64.t;
    var param_12:W64.t;
    var param_13:BArray128.t;
    var param_14:BArray64.t;
    var result_7:W64.t;
    var result_8:BArray64.t;
    var param_15:W64.t;
    var result_9:W64.t;
    var param_16:W32.t;
    var result_10:W32.t;
    var b_result:BArray64.t;
    var b_param:BArray128.t;
    var b_result_0:BArray128.t;
    var b_param_0:BArray128.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_2:BArray128.t;
    var trace__sha512_256___sha512_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_9 <- witness;
    param_13 <- witness;
    param_14 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_8 <- witness;
    trace__sha512_256___sha512_finalize <- [];
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128))))))]);
    fill <- total;
    fill <- (fill `&` (W64.of_int 127));
    t <- (W64.of_int 128);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++
    [(Assert,
     ((0 <= (W64.to_uint fill)) /\ (((W64.to_uint fill) + 1) <= 128)))]);
    b_buf <- (BArray128.set8d b_buf (W64.to_uint fill) (W8.of_int 255));
    buf <- (BArray128.set8 buf (W64.to_uint fill) (truncateu8 t));
    fill <- (fill + (W64.of_int 1));
    two_blocks <- ((W64.of_int 112) \ult fill);
    if (two_blocks) {
      ms <- (update_msf two_blocks ms);
      hi <- (W64.of_int 128);
      b_param_2 <- b_buf;
      param_2 <- buf;
      param_1 <- fill;
      param_0 <- hi;
      param <- ms;
      (result_0, b_result_2, result, tmp__trace) <@ __zero128 (param_2,
      b_param_2, param_1, param_0, param);
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++ tmp__trace);
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, (BArray128.is_init b_result_2 0 (W64.to_uint param_0)))]);
      b_buf <- b_result_2;
      buf <- result_0;
      ms <- result;
      (* Erased call to spill *)
      param_5 <- h;
      b_param_1 <- b_buf;
      param_4 <- buf;
      param_3 <- ms;
      (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_5,
      (BArray64.init_arr (W8.of_int 255)), param_4, b_param_1, param_3);
      result_2 <- aux;
      b_result_1 <- aux_0;
      result_1 <- aux_1;
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++ tmp__trace);
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      h <- result_2;
      ms <- result_1;
      (* Erased call to unspill *)
      b_out <- b_out;
      out <- (protect_ptr out ms);
      b_buf <- b_buf;
      buf <- (protect_ptr buf ms);
      total <- (protect_64 total ms);
      fill <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! two_blocks) ms);
    }
    hi <- (W64.of_int 112);
    b_param_0 <- b_buf;
    param_9 <- buf;
    param_8 <- fill;
    param_7 <- hi;
    param_6 <- ms;
    (result_4, b_result_0, result_3, tmp__trace) <@ __zero128 (param_9,
    b_param_0, param_8, param_7, param_6);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++ tmp__trace);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++
    [(Assert, (BArray128.is_init b_result_0 0 (W64.to_uint param_7)))]);
    b_buf <- b_result_0;
    buf <- result_4;
    ms <- result_3;
    t <- total;
    t <- (t `>>` (W8.of_int 61));
    param_10 <- t;
    (result_5, tmp__trace) <@ __bswap64 (param_10);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++ tmp__trace);
    t <- result_5;
    b_buf <- (BArray128.set64d b_buf 112 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 112 t);
    t <- total;
    t <- (t `<<` (W8.of_int 3));
    param_11 <- t;
    (result_6, tmp__trace) <@ __bswap64 (param_11);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++ tmp__trace);
    t <- result_6;
    b_buf <- (BArray128.set64d b_buf 120 (W64.of_int 18446744073709551615));
    buf <- (BArray128.set64d buf 120 t);
    (* Erased call to spill *)
    param_14 <- h;
    b_param <- b_buf;
    param_13 <- buf;
    param_12 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_14,
    (BArray64.init_arr (W8.of_int 255)), param_13, b_param, param_12);
    result_8 <- aux;
    b_result <- aux_0;
    result_7 <- aux_1;
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++ tmp__trace);
    trace__sha512_256___sha512_finalize <-
    (trace__sha512_256___sha512_finalize ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    h <- result_8;
    ms <- result_7;
    (* Erased call to unspill *)
    b_out <- b_out;
    out <- (protect_ptr out ms);
    b_buf <- b_buf;
    buf <- (protect_ptr buf ms);
    i <- 0;
    while ((i < 4)) {
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      param_15 <- x;
      (result_9, tmp__trace) <@ __bswap64 (param_15);
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++ tmp__trace);
      x <- result_9;
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 32)))]);
      b_out <-
      (BArray32.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
      out <- (BArray32.set64 out i x);
      i <- (i + 1);
    }
    i <- 4;
    while ((i < 4)) {
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      x <- (BArray64.get64 h i);
      x <- (x `>>` (W8.of_int 32));
      y <- (truncateu32 x);
      param_16 <- y;
      (result_10, tmp__trace) <@ __bswap32 (param_16);
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++ tmp__trace);
      y <- result_10;
      trace__sha512_256___sha512_finalize <-
      (trace__sha512_256___sha512_finalize ++
      [(Assert, ((0 <= ((2 * i) * 4)) /\ ((((2 * i) * 4) + 4) <= 32)))]);
      b_out <- (BArray32.set32d b_out ((2 * i) * 4) (W32.of_int 4294967295));
      out <- (BArray32.set32 out (2 * i) y);
      i <- (i + 1);
    }
    b_h <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, h, b_h, buf, b_buf, ms,
           trace__sha512_256___sha512_finalize);
  }
  proc _sha512_256____sha512_mem_from (out:BArray32.t, b_out:BArray32.t,
                                       h:BArray64.t, b_h:BArray64.t,
                                       in_0:W64.t, inlen:W64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux_5:BArray32.t;
    var aux_6:BArray32.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var buf_s:BArray128.t;
    var buf:BArray128.t;
    var total:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray128.t;
    var param_4:BArray64.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray128.t;
    var result_2:BArray64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray128.t;
    var param_8:BArray64.t;
    var param_9:BArray32.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var result_6:BArray32.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray32.t;
    var b_param:BArray128.t;
    var b_param_0:BArray32.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var b_buf_s:BArray128.t;
    var trace__sha512_256____sha512_mem_from:trace;
    b_buf <- witness;
    b_buf_s <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    buf_s <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace__sha512_256____sha512_mem_from <- [];
    trace__sha512_256____sha512_mem_from <-
    (trace__sha512_256____sha512_mem_from ++
    [(Assert,
     ((BArray64.is_init b_h 0 64) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_buf_s <- (BArray128.init_arr (W8.of_int 0));
    b_buf <- b_buf_s;
    buf <- buf_s;
    total <- (W64.of_int 0);
    (* Erased call to spill *)
    param_4 <- h;
    b_param_1 <- b_buf;
    param_3 <- buf;
    param_2 <- total;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha512_absorb_mem (
    param_4, (BArray64.init_arr (W8.of_int 255)), param_3, b_param_1,
    param_2, param_1, param_0, param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace__sha512_256____sha512_mem_from <-
    (trace__sha512_256____sha512_mem_from ++ tmp__trace);
    trace__sha512_256____sha512_mem_from <-
    (trace__sha512_256____sha512_mem_from ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0
      (W64.to_uint (result_0 \umod (W64.of_int 128))))) /\
     (result_0 = (param_2 + param_0))))]);
    h <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_9 <- out;
    param_8 <- h;
    b_param <- b_buf;
    param_7 <- buf;
    param_6 <- total;
    param_5 <- ms;
    (aux_5, aux_6, aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ _sha512_256___sha512_finalize (
    param_9, b_param_0, param_8, (BArray64.init_arr (W8.of_int 255)),
    param_7, b_param, param_6, param_5);
    result_6 <- aux_5;
    b_result_1 <- aux_6;
    result_5 <- aux;
    b_result_0 <- aux_0;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace__sha512_256____sha512_mem_from <-
    (trace__sha512_256____sha512_mem_from ++ tmp__trace);
    trace__sha512_256____sha512_mem_from <-
    (trace__sha512_256____sha512_mem_from ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_6;
    ms <- result_3;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512_256____sha512_mem_from);
  }
  proc _sha512_mem (out:BArray64.t, b_out:BArray64.t, in_0:W64.t,
                    inlen:W64.t, ms:W64.t) : BArray64.t * BArray64.t *
                                             W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var h:BArray64.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray64.t;
    var result_0:W64.t;
    var result_1:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var b_h:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var trace__sha512_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha512_mem <- [];
    trace__sha512_mem <-
    (trace__sha512_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray64.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha512_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha512_mem <- (trace__sha512_mem ++ tmp__trace);
    trace__sha512_mem <-
    (trace__sha512_mem ++ [(Assert, (BArray64.is_init b_result_0 0 64))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha512____sha512_mem_from (
    param_4, b_param, param_3, (BArray64.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha512_mem <- (trace__sha512_mem ++ tmp__trace);
    trace__sha512_mem <-
    (trace__sha512_mem ++ [(Assert, (BArray64.is_init b_result 0 64))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512_mem);
  }
  proc _sha384_mem (out:BArray48.t, b_out:BArray48.t, in_0:W64.t,
                    inlen:W64.t, ms:W64.t) : BArray48.t * BArray48.t *
                                             W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var h:BArray64.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray48.t;
    var result_0:W64.t;
    var result_1:BArray48.t;
    var b_result:BArray48.t;
    var b_param:BArray48.t;
    var b_h:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var trace__sha384_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha384_mem <- [];
    trace__sha384_mem <-
    (trace__sha384_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray64.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha384_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha384_mem <- (trace__sha384_mem ++ tmp__trace);
    trace__sha384_mem <-
    (trace__sha384_mem ++ [(Assert, (BArray64.is_init b_result_0 0 64))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha384____sha512_mem_from (
    param_4, b_param, param_3, (BArray64.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha384_mem <- (trace__sha384_mem ++ tmp__trace);
    trace__sha384_mem <-
    (trace__sha384_mem ++ [(Assert, (BArray48.is_init b_result 0 48))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray48.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha384_mem);
  }
  proc _sha512_224_mem (out:BArray28.t, b_out:BArray28.t, in_0:W64.t,
                        inlen:W64.t, ms:W64.t) : BArray28.t * BArray28.t *
                                                 W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var h:BArray64.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray28.t;
    var result_0:W64.t;
    var result_1:BArray28.t;
    var b_result:BArray28.t;
    var b_param:BArray28.t;
    var b_h:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var trace__sha512_224_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha512_224_mem <- [];
    trace__sha512_224_mem <-
    (trace__sha512_224_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray64.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha512_224_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha512_224_mem <- (trace__sha512_224_mem ++ tmp__trace);
    trace__sha512_224_mem <-
    (trace__sha512_224_mem ++ [(Assert, (BArray64.is_init b_result_0 0 64))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha512_224____sha512_mem_from (
    param_4, b_param, param_3, (BArray64.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha512_224_mem <- (trace__sha512_224_mem ++ tmp__trace);
    trace__sha512_224_mem <-
    (trace__sha512_224_mem ++ [(Assert, (BArray28.is_init b_result 0 28))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray28.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512_224_mem);
  }
  proc _sha512_256_mem (out:BArray32.t, b_out:BArray32.t, in_0:W64.t,
                        inlen:W64.t, ms:W64.t) : BArray32.t * BArray32.t *
                                                 W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var h:BArray64.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray32.t;
    var result_0:W64.t;
    var result_1:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray32.t;
    var b_h:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var trace__sha512_256_mem:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace__sha512_256_mem <- [];
    trace__sha512_256_mem <-
    (trace__sha512_256_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    b_h <- (BArray64.init_arr (W8.of_int 0));
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha512_256_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace__sha512_256_mem <- (trace__sha512_256_mem ++ tmp__trace);
    trace__sha512_256_mem <-
    (trace__sha512_256_mem ++ [(Assert, (BArray64.is_init b_result_0 0 64))]);
    h <- result;
    b_param <- b_out;
    param_4 <- out;
    param_3 <- h;
    param_2 <- in_0;
    param_1 <- inlen;
    param_0 <- ms;
    (result_1, b_result, result_0, tmp__trace) <@ _sha512_256____sha512_mem_from (
    param_4, b_param, param_3, (BArray64.init_arr (W8.of_int 255)), param_2,
    param_1, param_0);
    trace__sha512_256_mem <- (trace__sha512_256_mem ++ tmp__trace);
    trace__sha512_256_mem <-
    (trace__sha512_256_mem ++ [(Assert, (BArray32.is_init b_result 0 32))]);
    out <- result_1;
    ms <- result_0;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__sha512_256_mem);
  }
  proc _hmac_sha256_keyblock_mem (k0:BArray64.t, b_k0:BArray64.t, key:W64.t,
                                  keylen:W64.t, ms:W64.t) : BArray64.t *
                                                            BArray64.t *
                                                            W64.t * trace = {
    var long:bool;
    var i:W64.t;
    var digest:BArray32.t;
    var j:int;
    var t:W64.t;
    var hi:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var param_3:W64.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:W64.t;
    var param_11:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var b_digest:BArray32.t;
    var b_result_0:BArray32.t;
    var b_param_0:BArray32.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray64.t;
    var trace__hmac_sha256_keyblock_mem:trace;
    b_digest <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    digest <- witness;
    param_2 <- witness;
    param_7 <- witness;
    param_11 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    trace__hmac_sha256_keyblock_mem <- [];
    trace__hmac_sha256_keyblock_mem <-
    (trace__hmac_sha256_keyblock_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)))]);
    b_digest <- (BArray32.init_arr (W8.of_int 0));
    long <- ((W64.of_int 64) \ult keylen);
    if (long) {
      ms <- (update_msf long ms);
      (* Erased call to spill *)
      b_param_0 <- b_digest;
      param_2 <- digest;
      param_1 <- key;
      param_0 <- keylen;
      param <- ms;
      (result_0, b_result_0, result, tmp__trace) <@ _sha256_mem (param_2,
      b_param_0, param_1, param_0, param);
      trace__hmac_sha256_keyblock_mem <-
      (trace__hmac_sha256_keyblock_mem ++ tmp__trace);
      trace__hmac_sha256_keyblock_mem <-
      (trace__hmac_sha256_keyblock_mem ++
      [(Assert, (BArray32.is_init b_result_0 0 32))]);
      digest <- result_0;
      ms <- result;
      (* Erased call to unspill *)
      b_k0 <- b_k0;
      k0 <- (protect_ptr k0 ms);
      j <- 0;
      while ((j < 4)) {
        trace__hmac_sha256_keyblock_mem <-
        (trace__hmac_sha256_keyblock_mem ++
        [(Assert, ((0 <= (j * 8)) /\ (((j * 8) + 8) <= 32)))]);
        t <- (BArray32.get64 digest j);
        trace__hmac_sha256_keyblock_mem <-
        (trace__hmac_sha256_keyblock_mem ++
        [(Assert, ((0 <= (j * 8)) /\ (((j * 8) + 8) <= 64)))]);
        b_k0 <-
        (BArray64.set64d b_k0 (j * 8) (W64.of_int 18446744073709551615));
        k0 <- (BArray64.set64 k0 j t);
        j <- (j + 1);
      }
      i <- (W64.of_int 32);
    } else {
      ms <- (update_msf (! long) ms);
      i <- (W64.of_int 0);
      b_param_1 <- b_k0;
      param_7 <- k0;
      param_6 <- i;
      param_5 <- key;
      param_4 <- keylen;
      param_3 <- ms;
      (result_2, b_result_1, result_1, tmp__trace) <@ __fill64_mem (param_7,
      b_param_1, param_6, param_5, param_4, param_3);
      trace__hmac_sha256_keyblock_mem <-
      (trace__hmac_sha256_keyblock_mem ++ tmp__trace);
      trace__hmac_sha256_keyblock_mem <-
      (trace__hmac_sha256_keyblock_mem ++
      [(Assert,
       (BArray64.is_init b_result_1 0 (W64.to_uint (param_6 + param_4))))]);
      b_k0 <- b_result_1;
      k0 <- result_2;
      ms <- result_1;
      i <- keylen;
    }
    hi <- (W64.of_int 64);
    b_param <- b_k0;
    param_11 <- k0;
    param_10 <- i;
    param_9 <- hi;
    param_8 <- ms;
    (result_4, b_result, result_3, tmp__trace) <@ __zero64 (param_11,
    b_param, param_10, param_9, param_8);
    trace__hmac_sha256_keyblock_mem <-
    (trace__hmac_sha256_keyblock_mem ++ tmp__trace);
    trace__hmac_sha256_keyblock_mem <-
    (trace__hmac_sha256_keyblock_mem ++
    [(Assert, (BArray64.is_init b_result 0 (W64.to_uint param_9)))]);
    b_k0 <- b_result;
    k0 <- result_4;
    ms <- result_3;
    return (k0, b_k0, ms, trace__hmac_sha256_keyblock_mem);
  }
  proc _hmac_sha512_keyblock_mem (k0:BArray128.t, b_k0:BArray128.t,
                                  key:W64.t, keylen:W64.t, ms:W64.t) : 
  BArray128.t * BArray128.t * W64.t * trace = {
    var long:bool;
    var i:W64.t;
    var digest:BArray64.t;
    var j:int;
    var t:W64.t;
    var hi:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_3:W64.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:W64.t;
    var param_7:BArray128.t;
    var result_1:W64.t;
    var result_2:BArray128.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:W64.t;
    var param_11:BArray128.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var b_result:BArray128.t;
    var b_param:BArray128.t;
    var b_digest:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var b_result_1:BArray128.t;
    var b_param_1:BArray128.t;
    var trace__hmac_sha512_keyblock_mem:trace;
    b_digest <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    digest <- witness;
    param_2 <- witness;
    param_7 <- witness;
    param_11 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    trace__hmac_sha512_keyblock_mem <- [];
    trace__hmac_sha512_keyblock_mem <-
    (trace__hmac_sha512_keyblock_mem ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)))]);
    b_digest <- (BArray64.init_arr (W8.of_int 0));
    long <- ((W64.of_int 128) \ult keylen);
    if (long) {
      ms <- (update_msf long ms);
      (* Erased call to spill *)
      b_param_0 <- b_digest;
      param_2 <- digest;
      param_1 <- key;
      param_0 <- keylen;
      param <- ms;
      (result_0, b_result_0, result, tmp__trace) <@ _sha512_mem (param_2,
      b_param_0, param_1, param_0, param);
      trace__hmac_sha512_keyblock_mem <-
      (trace__hmac_sha512_keyblock_mem ++ tmp__trace);
      trace__hmac_sha512_keyblock_mem <-
      (trace__hmac_sha512_keyblock_mem ++
      [(Assert, (BArray64.is_init b_result_0 0 64))]);
      digest <- result_0;
      ms <- result;
      (* Erased call to unspill *)
      b_k0 <- b_k0;
      k0 <- (protect_ptr k0 ms);
      j <- 0;
      while ((j < 8)) {
        trace__hmac_sha512_keyblock_mem <-
        (trace__hmac_sha512_keyblock_mem ++
        [(Assert, ((0 <= (j * 8)) /\ (((j * 8) + 8) <= 64)))]);
        t <- (BArray64.get64 digest j);
        trace__hmac_sha512_keyblock_mem <-
        (trace__hmac_sha512_keyblock_mem ++
        [(Assert, ((0 <= (j * 8)) /\ (((j * 8) + 8) <= 128)))]);
        b_k0 <-
        (BArray128.set64d b_k0 (j * 8) (W64.of_int 18446744073709551615));
        k0 <- (BArray128.set64 k0 j t);
        j <- (j + 1);
      }
      i <- (W64.of_int 64);
    } else {
      ms <- (update_msf (! long) ms);
      i <- (W64.of_int 0);
      b_param_1 <- b_k0;
      param_7 <- k0;
      param_6 <- i;
      param_5 <- key;
      param_4 <- keylen;
      param_3 <- ms;
      (result_2, b_result_1, result_1, tmp__trace) <@ __fill128_mem (
      param_7, b_param_1, param_6, param_5, param_4, param_3);
      trace__hmac_sha512_keyblock_mem <-
      (trace__hmac_sha512_keyblock_mem ++ tmp__trace);
      trace__hmac_sha512_keyblock_mem <-
      (trace__hmac_sha512_keyblock_mem ++
      [(Assert,
       (BArray128.is_init b_result_1 0 (W64.to_uint (param_6 + param_4))))]);
      b_k0 <- b_result_1;
      k0 <- result_2;
      ms <- result_1;
      i <- keylen;
    }
    hi <- (W64.of_int 128);
    b_param <- b_k0;
    param_11 <- k0;
    param_10 <- i;
    param_9 <- hi;
    param_8 <- ms;
    (result_4, b_result, result_3, tmp__trace) <@ __zero128 (param_11,
    b_param, param_10, param_9, param_8);
    trace__hmac_sha512_keyblock_mem <-
    (trace__hmac_sha512_keyblock_mem ++ tmp__trace);
    trace__hmac_sha512_keyblock_mem <-
    (trace__hmac_sha512_keyblock_mem ++
    [(Assert, (BArray128.is_init b_result 0 (W64.to_uint param_9)))]);
    b_k0 <- b_result;
    k0 <- result_4;
    ms <- result_3;
    return (k0, b_k0, ms, trace__hmac_sha512_keyblock_mem);
  }
  proc __hmac_sha256_init (inner:BArray32.t, b_inner:BArray32.t,
                           outer:BArray32.t, b_outer:BArray32.t,
                           k0:BArray64.t, b_k0:BArray64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * BArray32.t * BArray32.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:W64.t;
    var mi:W64.t;
    var mo:W64.t;
    var i:int;
    var t:W64.t;
    var u:W64.t;
    var ipad:BArray64.t;
    var opad:BArray64.t;
    var param:BArray32.t;
    var result:BArray32.t;
    var param_0:W64.t;
    var param_1:BArray64.t;
    var param_2:BArray32.t;
    var result_0:W64.t;
    var result_1:BArray32.t;
    var param_3:BArray32.t;
    var result_2:BArray32.t;
    var param_4:W64.t;
    var param_5:BArray64.t;
    var param_6:BArray32.t;
    var result_3:W64.t;
    var result_4:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray64.t;
    var b_opad:BArray64.t;
    var b_result_0:BArray32.t;
    var b_param_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param_1:BArray64.t;
    var b_ipad:BArray64.t;
    var b_result_2:BArray32.t;
    var b_param_2:BArray32.t;
    var trace___hmac_sha256_init:trace;
    b_ipad <- witness;
    b_opad <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    ipad <- witness;
    opad <- witness;
    param <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    result <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    trace___hmac_sha256_init <- [];
    trace___hmac_sha256_init <-
    (trace___hmac_sha256_init ++ [(Assert, (BArray64.is_init b_k0 0 64))]);
    b_ipad <- (BArray64.init_arr (W8.of_int 0));
    b_opad <- (BArray64.init_arr (W8.of_int 0));
    mi <- (W64.of_int 3906369333256140342);
    mo <- (W64.of_int 6655295901103053916);
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha256_init <-
      (trace___hmac_sha256_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 k0 i);
      u <- t;
      t <- (t `^` mi);
      u <- (u `^` mo);
      trace___hmac_sha256_init <-
      (trace___hmac_sha256_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_ipad <-
      (BArray64.set64d b_ipad (i * 8) (W64.of_int 18446744073709551615));
      ipad <- (BArray64.set64 ipad i t);
      trace___hmac_sha256_init <-
      (trace___hmac_sha256_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_opad <-
      (BArray64.set64d b_opad (i * 8) (W64.of_int 18446744073709551615));
      opad <- (BArray64.set64 opad i u);
      i <- (i + 1);
    }
    b_param_2 <- b_inner;
    param <- inner;
    (aux, aux_0, tmp__trace) <@ __sha256_init (param, b_param_2);
    result <- aux;
    b_result_2 <- aux_0;
    trace___hmac_sha256_init <- (trace___hmac_sha256_init ++ tmp__trace);
    trace___hmac_sha256_init <-
    (trace___hmac_sha256_init ++
    [(Assert, (BArray32.is_init b_result_2 0 32))]);
    inner <- result;
    param_2 <- inner;
    b_param_1 <- b_ipad;
    param_1 <- ipad;
    param_0 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_2,
    (BArray32.init_arr (W8.of_int 255)), param_1, b_param_1, param_0);
    result_1 <- aux;
    b_result_1 <- aux_0;
    result_0 <- aux_1;
    trace___hmac_sha256_init <- (trace___hmac_sha256_init ++ tmp__trace);
    trace___hmac_sha256_init <-
    (trace___hmac_sha256_init ++
    [(Assert, (BArray32.is_init b_result_1 0 32))]);
    inner <- result_1;
    ms <- result_0;
    b_param_0 <- b_outer;
    param_3 <- outer;
    (aux, aux_0, tmp__trace) <@ __sha256_init (param_3, b_param_0);
    result_2 <- aux;
    b_result_0 <- aux_0;
    trace___hmac_sha256_init <- (trace___hmac_sha256_init ++ tmp__trace);
    trace___hmac_sha256_init <-
    (trace___hmac_sha256_init ++
    [(Assert, (BArray32.is_init b_result_0 0 32))]);
    outer <- result_2;
    param_6 <- outer;
    b_param <- b_opad;
    param_5 <- opad;
    param_4 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha256_compress (param_6,
    (BArray32.init_arr (W8.of_int 255)), param_5, b_param, param_4);
    result_4 <- aux;
    b_result <- aux_0;
    result_3 <- aux_1;
    trace___hmac_sha256_init <- (trace___hmac_sha256_init ++ tmp__trace);
    trace___hmac_sha256_init <-
    (trace___hmac_sha256_init ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    outer <- result_4;
    ms <- result_3;
    b_outer <- (BArray32.init_arr (W8.of_int 255));
    b_inner <- (BArray32.init_arr (W8.of_int 255));
    return (inner, b_inner, outer, b_outer, ms, trace___hmac_sha256_init);
  }
  proc __hmac_sha512_init (inner:BArray64.t, b_inner:BArray64.t,
                           outer:BArray64.t, b_outer:BArray64.t,
                           k0:BArray128.t, b_k0:BArray128.t, ms:W64.t) : 
  BArray64.t * BArray64.t * BArray64.t * BArray64.t * W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:W64.t;
    var mi:W64.t;
    var mo:W64.t;
    var i:int;
    var t:W64.t;
    var u:W64.t;
    var ipad:BArray128.t;
    var opad:BArray128.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var result_0:W64.t;
    var result_1:BArray64.t;
    var param_3:BArray64.t;
    var result_2:BArray64.t;
    var param_4:W64.t;
    var param_5:BArray128.t;
    var param_6:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray128.t;
    var b_opad:BArray128.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param_1:BArray128.t;
    var b_ipad:BArray128.t;
    var b_result_2:BArray64.t;
    var b_param_2:BArray64.t;
    var trace___hmac_sha512_init:trace;
    b_ipad <- witness;
    b_opad <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    ipad <- witness;
    opad <- witness;
    param <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    result <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    trace___hmac_sha512_init <- [];
    trace___hmac_sha512_init <-
    (trace___hmac_sha512_init ++ [(Assert, (BArray128.is_init b_k0 0 128))]);
    b_ipad <- (BArray128.init_arr (W8.of_int 0));
    b_opad <- (BArray128.init_arr (W8.of_int 0));
    mi <- (W64.of_int 3906369333256140342);
    mo <- (W64.of_int 6655295901103053916);
    i <- 0;
    while ((i < 16)) {
      trace___hmac_sha512_init <-
      (trace___hmac_sha512_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 128)))]);
      t <- (BArray128.get64 k0 i);
      u <- t;
      t <- (t `^` mi);
      u <- (u `^` mo);
      trace___hmac_sha512_init <-
      (trace___hmac_sha512_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 128)))]);
      b_ipad <-
      (BArray128.set64d b_ipad (i * 8) (W64.of_int 18446744073709551615));
      ipad <- (BArray128.set64 ipad i t);
      trace___hmac_sha512_init <-
      (trace___hmac_sha512_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 128)))]);
      b_opad <-
      (BArray128.set64d b_opad (i * 8) (W64.of_int 18446744073709551615));
      opad <- (BArray128.set64 opad i u);
      i <- (i + 1);
    }
    b_param_2 <- b_inner;
    param <- inner;
    (aux, aux_0, tmp__trace) <@ __sha512_init (param, b_param_2);
    result <- aux;
    b_result_2 <- aux_0;
    trace___hmac_sha512_init <- (trace___hmac_sha512_init ++ tmp__trace);
    trace___hmac_sha512_init <-
    (trace___hmac_sha512_init ++
    [(Assert, (BArray64.is_init b_result_2 0 64))]);
    inner <- result;
    param_2 <- inner;
    b_param_1 <- b_ipad;
    param_1 <- ipad;
    param_0 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_2,
    (BArray64.init_arr (W8.of_int 255)), param_1, b_param_1, param_0);
    result_1 <- aux;
    b_result_1 <- aux_0;
    result_0 <- aux_1;
    trace___hmac_sha512_init <- (trace___hmac_sha512_init ++ tmp__trace);
    trace___hmac_sha512_init <-
    (trace___hmac_sha512_init ++
    [(Assert, (BArray64.is_init b_result_1 0 64))]);
    inner <- result_1;
    ms <- result_0;
    b_param_0 <- b_outer;
    param_3 <- outer;
    (aux, aux_0, tmp__trace) <@ __sha512_init (param_3, b_param_0);
    result_2 <- aux;
    b_result_0 <- aux_0;
    trace___hmac_sha512_init <- (trace___hmac_sha512_init ++ tmp__trace);
    trace___hmac_sha512_init <-
    (trace___hmac_sha512_init ++
    [(Assert, (BArray64.is_init b_result_0 0 64))]);
    outer <- result_2;
    param_6 <- outer;
    b_param <- b_opad;
    param_5 <- opad;
    param_4 <- ms;
    (aux, aux_0, aux_1, tmp__trace) <@ _sha512_compress (param_6,
    (BArray64.init_arr (W8.of_int 255)), param_5, b_param, param_4);
    result_4 <- aux;
    b_result <- aux_0;
    result_3 <- aux_1;
    trace___hmac_sha512_init <- (trace___hmac_sha512_init ++ tmp__trace);
    trace___hmac_sha512_init <-
    (trace___hmac_sha512_init ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    outer <- result_4;
    ms <- result_3;
    b_outer <- (BArray64.init_arr (W8.of_int 255));
    b_inner <- (BArray64.init_arr (W8.of_int 255));
    return (inner, b_inner, outer, b_outer, ms, trace___hmac_sha512_init);
  }
  proc __hmac_sha256_outer (inner:BArray32.t, b_inner:BArray32.t,
                            buf:BArray64.t, b_buf:BArray64.t, total:W64.t,
                            outer:BArray32.t, b_outer:BArray32.t, ms:W64.t) : 
  BArray32.t * BArray32.t * BArray64.t * BArray64.t * W64.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray32.t;
    var aux_2:BArray32.t;
    var aux_3:BArray64.t;
    var aux_4:BArray64.t;
    var aux_5:W64.t;
    var digest:BArray32.t;
    var i:int;
    var x:W32.t;
    var t:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray64.t;
    var param_2:BArray32.t;
    var param_3:BArray32.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var result_1:BArray32.t;
    var result_2:BArray32.t;
    var b_digest:BArray32.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var trace___hmac_sha256_outer:trace;
    b_digest <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    digest <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace___hmac_sha256_outer <- [];
    trace___hmac_sha256_outer <-
    (trace___hmac_sha256_outer ++
    [(Assert,
     (((BArray32.is_init b_inner 0 32) /\
      (BArray64.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 64))))) /\
     (BArray32.is_init b_outer 0 32)))]);
    b_digest <- (BArray32.init_arr (W8.of_int 0));
    b_param_0 <- b_digest;
    param_3 <- digest;
    param_2 <- inner;
    b_param <- b_buf;
    param_1 <- buf;
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha256___sha256_finalize (
    param_3, b_param_0, param_2, (BArray32.init_arr (W8.of_int 255)),
    param_1, b_param, param_0, param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace___hmac_sha256_outer <- (trace___hmac_sha256_outer ++ tmp__trace);
    trace___hmac_sha256_outer <-
    (trace___hmac_sha256_outer ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    digest <- result_2;
    inner <- result_1;
    buf <- result_0;
    ms <- result;
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha256_outer <-
      (trace___hmac_sha256_outer ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      x <- (BArray32.get32 outer i);
      trace___hmac_sha256_outer <-
      (trace___hmac_sha256_outer ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      inner <- (BArray32.set32 inner i x);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 4)) {
      trace___hmac_sha256_outer <-
      (trace___hmac_sha256_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 32)))]);
      t <- (BArray32.get64 digest i);
      trace___hmac_sha256_outer <-
      (trace___hmac_sha256_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      buf <- (BArray64.set64 buf i t);
      i <- (i + 1);
    }
    total <- (W64.of_int 96);
    b_inner <- (BArray32.init_arr (W8.of_int 255));
    b_buf <- (BArray64.init_arr (W8.of_int 255));
    return (inner, b_inner, buf, b_buf, total, ms, trace___hmac_sha256_outer);
  }
  proc __hmac_sha256_finalize (out:BArray32.t, b_out:BArray32.t,
                               inner:BArray32.t, b_inner:BArray32.t,
                               buf:BArray64.t, b_buf:BArray64.t, total:W64.t,
                               outer:BArray32.t, b_outer:BArray32.t, ms:W64.t) : 
  BArray32.t * BArray32.t * BArray32.t * BArray32.t * BArray64.t *
  BArray64.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_5:BArray32.t;
    var aux_6:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var param:W64.t;
    var param_0:BArray32.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var param_3:BArray32.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray64.t;
    var result_2:BArray32.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:BArray64.t;
    var param_7:BArray32.t;
    var param_8:BArray32.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var result_5:BArray32.t;
    var result_6:BArray32.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_result_2:BArray64.t;
    var b_result_3:BArray32.t;
    var b_param_1:BArray64.t;
    var trace___hmac_sha256_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    param_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_6 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace___hmac_sha256_finalize <- [];
    trace___hmac_sha256_finalize <-
    (trace___hmac_sha256_finalize ++
    [(Assert,
     (((BArray32.is_init b_inner 0 32) /\
      (BArray64.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 64))))) /\
     (BArray32.is_init b_outer 0 32)))]);
    param_3 <- inner;
    b_param_1 <- b_buf;
    param_2 <- buf;
    param_1 <- total;
    param_0 <- outer;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ __hmac_sha256_outer (
    param_3, (BArray32.init_arr (W8.of_int 255)), param_2, b_param_1,
    param_1, param_0, (BArray32.init_arr (W8.of_int 255)), param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace___hmac_sha256_finalize <-
    (trace___hmac_sha256_finalize ++ tmp__trace);
    trace___hmac_sha256_finalize <-
    (trace___hmac_sha256_finalize ++
    [(Assert,
     (((BArray32.is_init b_result_3 0 32) /\
      (BArray64.is_init b_result_2 0 32)) /\
     (result_0 = (W64.of_int 96))))]);
    inner <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    b_param_0 <- b_out;
    param_8 <- out;
    param_7 <- inner;
    b_param <- b_buf;
    param_6 <- buf;
    param_5 <- total;
    param_4 <- ms;
    (aux, aux_0, aux_5, aux_6, aux_1, aux_2, aux_3, tmp__trace) <@ _sha256___sha256_finalize (
    param_8, b_param_0, param_7, (BArray32.init_arr (W8.of_int 255)),
    param_6, b_param, param_5, param_4);
    result_6 <- aux;
    b_result_1 <- aux_0;
    result_5 <- aux_5;
    b_result_0 <- aux_6;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace___hmac_sha256_finalize <-
    (trace___hmac_sha256_finalize ++ tmp__trace);
    trace___hmac_sha256_finalize <-
    (trace___hmac_sha256_finalize ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    out <- result_6;
    b_inner <- (BArray32.init_arr (W8.of_int 255));
    inner <- result_5;
    b_buf <- (BArray64.init_arr (W8.of_int 255));
    buf <- result_4;
    ms <- result_3;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, inner, b_inner, buf, b_buf, ms,
           trace___hmac_sha256_finalize);
  }
  proc __hmac_sha512_outer (inner:BArray64.t, b_inner:BArray64.t,
                            buf:BArray128.t, b_buf:BArray128.t, total:W64.t,
                            outer:BArray64.t, b_outer:BArray64.t, ms:W64.t) : 
  BArray64.t * BArray64.t * BArray128.t * BArray128.t * W64.t * W64.t * trace = {
    var aux_3:BArray128.t;
    var aux_4:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var digest:BArray64.t;
    var i:int;
    var t:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var param_3:BArray64.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var result_1:BArray64.t;
    var result_2:BArray64.t;
    var b_digest:BArray64.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var trace___hmac_sha512_outer:trace;
    b_digest <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    digest <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace___hmac_sha512_outer <- [];
    trace___hmac_sha512_outer <-
    (trace___hmac_sha512_outer ++
    [(Assert,
     (((BArray64.is_init b_inner 0 64) /\
      (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128)))
      )) /\
     (BArray64.is_init b_outer 0 64)))]);
    b_digest <- (BArray64.init_arr (W8.of_int 0));
    b_param_0 <- b_digest;
    param_3 <- digest;
    param_2 <- inner;
    b_param <- b_buf;
    param_1 <- buf;
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha512___sha512_finalize (
    param_3, b_param_0, param_2, (BArray64.init_arr (W8.of_int 255)),
    param_1, b_param, param_0, param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace___hmac_sha512_outer <- (trace___hmac_sha512_outer ++ tmp__trace);
    trace___hmac_sha512_outer <-
    (trace___hmac_sha512_outer ++
    [(Assert,
     (((BArray64.is_init b_result_1 0 64) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    digest <- result_2;
    inner <- result_1;
    buf <- result_0;
    ms <- result;
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha512_outer <-
      (trace___hmac_sha512_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 outer i);
      trace___hmac_sha512_outer <-
      (trace___hmac_sha512_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      inner <- (BArray64.set64 inner i t);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha512_outer <-
      (trace___hmac_sha512_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 digest i);
      trace___hmac_sha512_outer <-
      (trace___hmac_sha512_outer ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 128)))]);
      buf <- (BArray128.set64 buf i t);
      i <- (i + 1);
    }
    total <- (W64.of_int 192);
    b_inner <- (BArray64.init_arr (W8.of_int 255));
    b_buf <- (BArray128.init_arr (W8.of_int 255));
    return (inner, b_inner, buf, b_buf, total, ms, trace___hmac_sha512_outer);
  }
  proc __hmac_sha512_finalize (out:BArray64.t, b_out:BArray64.t,
                               inner:BArray64.t, b_inner:BArray64.t,
                               buf:BArray128.t, b_buf:BArray128.t,
                               total:W64.t, outer:BArray64.t,
                               b_outer:BArray64.t, ms:W64.t) : BArray64.t *
                                                               BArray64.t *
                                                               BArray64.t *
                                                               BArray64.t *
                                                               BArray128.t *
                                                               BArray128.t *
                                                               W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_5:BArray64.t;
    var aux_6:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var param:W64.t;
    var param_0:BArray64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var param_3:BArray64.t;
    var result:W64.t;
    var result_0:W64.t;
    var result_1:BArray128.t;
    var result_2:BArray64.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:BArray128.t;
    var param_7:BArray64.t;
    var param_8:BArray64.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var result_6:BArray64.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var trace___hmac_sha512_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    param_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_6 <- witness;
    param_7 <- witness;
    param_8 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    trace___hmac_sha512_finalize <- [];
    trace___hmac_sha512_finalize <-
    (trace___hmac_sha512_finalize ++
    [(Assert,
     (((BArray64.is_init b_inner 0 64) /\
      (BArray128.is_init b_buf 0 (W64.to_uint (total \umod (W64.of_int 128)))
      )) /\
     (BArray64.is_init b_outer 0 64)))]);
    param_3 <- inner;
    b_param_1 <- b_buf;
    param_2 <- buf;
    param_1 <- total;
    param_0 <- outer;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ __hmac_sha512_outer (
    param_3, (BArray64.init_arr (W8.of_int 255)), param_2, b_param_1,
    param_1, param_0, (BArray64.init_arr (W8.of_int 255)), param);
    result_2 <- aux;
    b_result_3 <- aux_0;
    result_1 <- aux_1;
    b_result_2 <- aux_2;
    result_0 <- aux_3;
    result <- aux_4;
    trace___hmac_sha512_finalize <-
    (trace___hmac_sha512_finalize ++ tmp__trace);
    trace___hmac_sha512_finalize <-
    (trace___hmac_sha512_finalize ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0 64)) /\
     (result_0 = (W64.of_int 192))))]);
    inner <- result_2;
    b_buf <- b_result_2;
    buf <- result_1;
    total <- result_0;
    ms <- result;
    b_param_0 <- b_out;
    param_8 <- out;
    param_7 <- inner;
    b_param <- b_buf;
    param_6 <- buf;
    param_5 <- total;
    param_4 <- ms;
    (aux, aux_0, aux_5, aux_6, aux_1, aux_2, aux_3, tmp__trace) <@ _sha512___sha512_finalize (
    param_8, b_param_0, param_7, (BArray64.init_arr (W8.of_int 255)),
    param_6, b_param, param_5, param_4);
    result_6 <- aux;
    b_result_1 <- aux_0;
    result_5 <- aux_5;
    b_result_0 <- aux_6;
    result_4 <- aux_1;
    b_result <- aux_2;
    result_3 <- aux_3;
    trace___hmac_sha512_finalize <-
    (trace___hmac_sha512_finalize ++ tmp__trace);
    trace___hmac_sha512_finalize <-
    (trace___hmac_sha512_finalize ++
    [(Assert,
     (((BArray64.is_init b_result_1 0 64) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_6;
    b_inner <- (BArray64.init_arr (W8.of_int 255));
    inner <- result_5;
    b_buf <- (BArray128.init_arr (W8.of_int 255));
    buf <- result_4;
    ms <- result_3;
    b_out <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, inner, b_inner, buf, b_buf, ms,
           trace___hmac_sha512_finalize);
  }
  proc __sha2_tag (f:int) : W64.t * trace = {
    var tag:W64.t;
    var trace___sha2_tag:trace;
    trace___sha2_tag <- [];
    tag <- (W64.of_int (1100356872307 + (f `<<` 32)));
    return (tag, trace___sha2_tag);
  }
  proc __sha2_ctx_open (head:BArray16.t, b_head:BArray16.t, ms:W64.t) : 
  W64.t * W64.t * trace = {
    var tag:W64.t;
    var total:W64.t;
    var trace___sha2_ctx_open:trace;
    trace___sha2_ctx_open <- [];
    trace___sha2_ctx_open <-
    (trace___sha2_ctx_open ++ [(Assert, (BArray16.is_init b_head 0 16))]);
    tag <- (BArray16.get64d head 0);
    total <- (BArray16.get64d head 8);
    (* Erased call to declassify *)
    (* Erased call to declassify *)
    tag <- (protect_64 tag ms);
    total <- (protect_64 total ms);
    return (tag, total, trace___sha2_ctx_open);
  }
  proc __sha2_room (total:W64.t) : W64.t * trace = {
    var room:W64.t;
    var limit:W64.t;
    var zero:W64.t;
    var trace___sha2_room:trace;
    trace___sha2_room <- [];
    limit <- (W64.of_int 2305843009213693952);
    zero <- (W64.of_int 0);
    room <- limit;
    room <- (room - total);
    room <- ((total \ult limit) ? room : zero);
    return (room, trace___sha2_room);
  }
  proc __sha256_ctx_load (h:BArray32.t, b_h:BArray32.t, buf:BArray64.t,
                          b_buf:BArray64.t, ctx:BArray112.t,
                          b_ctx:BArray112.t) : BArray32.t * BArray32.t *
                                               BArray64.t * BArray64.t *
                                               trace = {
    var i:int;
    var x:W32.t;
    var t:W64.t;
    var trace___sha256_ctx_load:trace;
    trace___sha256_ctx_load <- [];
    trace___sha256_ctx_load <-
    (trace___sha256_ctx_load ++ [(Assert, (BArray112.is_init b_ctx 0 112))]);
    i <- 0;
    while ((i < 8)) {
      trace___sha256_ctx_load <-
      (trace___sha256_ctx_load ++
      [(Assert, ((0 <= (16 + (4 * i))) /\ (((16 + (4 * i)) + 4) <= 112)))]);
      x <- (BArray112.get32d ctx (16 + (4 * i)));
      trace___sha256_ctx_load <-
      (trace___sha256_ctx_load ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      b_h <- (BArray32.set32d b_h (i * 4) (W32.of_int 4294967295));
      h <- (BArray32.set32 h i x);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 8)) {
      trace___sha256_ctx_load <-
      (trace___sha256_ctx_load ++
      [(Assert, ((0 <= (48 + (8 * i))) /\ (((48 + (8 * i)) + 8) <= 112)))]);
      t <- (BArray112.get64d ctx (48 + (8 * i)));
      trace___sha256_ctx_load <-
      (trace___sha256_ctx_load ++
      [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 64)))]);
      b_buf <-
      (BArray64.set64d b_buf (8 * i) (W64.of_int 18446744073709551615));
      buf <- (BArray64.set64d buf (8 * i) t);
      i <- (i + 1);
    }
    return (h, b_h, buf, b_buf, trace___sha256_ctx_load);
  }
  proc __sha512_ctx_load (h:BArray64.t, b_h:BArray64.t, buf:BArray128.t,
                          b_buf:BArray128.t, ctx:BArray208.t,
                          b_ctx:BArray208.t) : BArray64.t * BArray64.t *
                                               BArray128.t * BArray128.t *
                                               trace = {
    var i:int;
    var t:W64.t;
    var trace___sha512_ctx_load:trace;
    trace___sha512_ctx_load <- [];
    trace___sha512_ctx_load <-
    (trace___sha512_ctx_load ++ [(Assert, (BArray208.is_init b_ctx 0 208))]);
    i <- 0;
    while ((i < 8)) {
      trace___sha512_ctx_load <-
      (trace___sha512_ctx_load ++
      [(Assert, ((0 <= (16 + (8 * i))) /\ (((16 + (8 * i)) + 8) <= 208)))]);
      t <- (BArray208.get64d ctx (16 + (8 * i)));
      trace___sha512_ctx_load <-
      (trace___sha512_ctx_load ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      b_h <- (BArray64.set64d b_h (i * 8) (W64.of_int 18446744073709551615));
      h <- (BArray64.set64 h i t);
      i <- (i + 1);
    }
    i <- 0;
    while ((i < 16)) {
      trace___sha512_ctx_load <-
      (trace___sha512_ctx_load ++
      [(Assert, ((0 <= (80 + (8 * i))) /\ (((80 + (8 * i)) + 8) <= 208)))]);
      t <- (BArray208.get64d ctx (80 + (8 * i)));
      trace___sha512_ctx_load <-
      (trace___sha512_ctx_load ++
      [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 128)))]);
      b_buf <-
      (BArray128.set64d b_buf (8 * i) (W64.of_int 18446744073709551615));
      buf <- (BArray128.set64d buf (8 * i) t);
      i <- (i + 1);
    }
    return (h, b_h, buf, b_buf, trace___sha512_ctx_load);
  }
  proc __sha256_ctx_init (ctx:BArray112.t, b_ctx:BArray112.t, h:BArray32.t,
                          b_h:BArray32.t, tag:W64.t, total:W64.t) : BArray112.t *
                                                                    BArray112.t *
                                                                    trace = {
    var i:int;
    var x:W32.t;
    var z:W64.t;
    var trace___sha256_ctx_init:trace;
    trace___sha256_ctx_init <- [];
    trace___sha256_ctx_init <-
    (trace___sha256_ctx_init ++ [(Assert, (BArray32.is_init b_h 0 32))]);
    b_ctx <- (BArray112.set64d b_ctx 0 (W64.of_int 18446744073709551615));
    ctx <- (BArray112.set64d ctx 0 tag);
    b_ctx <- (BArray112.set64d b_ctx 8 (W64.of_int 18446744073709551615));
    ctx <- (BArray112.set64d ctx 8 total);
    i <- 0;
    while ((i < 8)) {
      trace___sha256_ctx_init <-
      (trace___sha256_ctx_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      x <- (BArray32.get32 h i);
      trace___sha256_ctx_init <-
      (trace___sha256_ctx_init ++
      [(Assert, ((0 <= (16 + (4 * i))) /\ (((16 + (4 * i)) + 4) <= 112)))]);
      b_ctx <-
      (BArray112.set32d b_ctx (16 + (4 * i)) (W32.of_int 4294967295));
      ctx <- (BArray112.set32d ctx (16 + (4 * i)) x);
      i <- (i + 1);
    }
    z <- (W64.of_int 0);
    i <- 0;
    while ((i < 8)) {
      trace___sha256_ctx_init <-
      (trace___sha256_ctx_init ++
      [(Assert, ((0 <= (48 + (8 * i))) /\ (((48 + (8 * i)) + 8) <= 112)))]);
      b_ctx <-
      (BArray112.set64d b_ctx (48 + (8 * i))
      (W64.of_int 18446744073709551615));
      ctx <- (BArray112.set64d ctx (48 + (8 * i)) z);
      i <- (i + 1);
    }
    return (ctx, b_ctx, trace___sha256_ctx_init);
  }
  proc __sha512_ctx_init (ctx:BArray208.t, b_ctx:BArray208.t, h:BArray64.t,
                          b_h:BArray64.t, tag:W64.t, total:W64.t) : BArray208.t *
                                                                    BArray208.t *
                                                                    trace = {
    var i:int;
    var t:W64.t;
    var z:W64.t;
    var trace___sha512_ctx_init:trace;
    trace___sha512_ctx_init <- [];
    trace___sha512_ctx_init <-
    (trace___sha512_ctx_init ++ [(Assert, (BArray64.is_init b_h 0 64))]);
    b_ctx <- (BArray208.set64d b_ctx 0 (W64.of_int 18446744073709551615));
    ctx <- (BArray208.set64d ctx 0 tag);
    b_ctx <- (BArray208.set64d b_ctx 8 (W64.of_int 18446744073709551615));
    ctx <- (BArray208.set64d ctx 8 total);
    i <- 0;
    while ((i < 8)) {
      trace___sha512_ctx_init <-
      (trace___sha512_ctx_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 h i);
      trace___sha512_ctx_init <-
      (trace___sha512_ctx_init ++
      [(Assert, ((0 <= (16 + (8 * i))) /\ (((16 + (8 * i)) + 8) <= 208)))]);
      b_ctx <-
      (BArray208.set64d b_ctx (16 + (8 * i))
      (W64.of_int 18446744073709551615));
      ctx <- (BArray208.set64d ctx (16 + (8 * i)) t);
      i <- (i + 1);
    }
    z <- (W64.of_int 0);
    i <- 0;
    while ((i < 16)) {
      trace___sha512_ctx_init <-
      (trace___sha512_ctx_init ++
      [(Assert, ((0 <= (80 + (8 * i))) /\ (((80 + (8 * i)) + 8) <= 208)))]);
      b_ctx <-
      (BArray208.set64d b_ctx (80 + (8 * i))
      (W64.of_int 18446744073709551615));
      ctx <- (BArray208.set64d ctx (80 + (8 * i)) z);
      i <- (i + 1);
    }
    return (ctx, b_ctx, trace___sha512_ctx_init);
  }
  proc _sha256_ctx_update (ctx:BArray112.t, b_ctx:BArray112.t, in_0:W64.t,
                           inlen:W64.t, expect_0:W64.t, ms:W64.t) : BArray112.t *
                                                                    BArray112.t *
                                                                    W64.t *
                                                                    W64.t *
                                                                    trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var room:W64.t;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var result_1:W64.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:BArray64.t;
    var param_7:BArray32.t;
    var result_2:W64.t;
    var result_3:W64.t;
    var result_4:BArray64.t;
    var result_5:BArray32.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_param_1:BArray16.t;
    var trace__sha256_ctx_update:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_6 <- witness;
    param_7 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    trace__sha256_ctx_update <- [];
    trace__sha256_ctx_update <-
    (trace__sha256_ctx_update ++
    [(Assert,
     ((BArray112.is_init b_ctx 0 112) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_param_1 <- (SBArray112_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray112_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_1,
    param);
    trace__sha256_ctx_update <- (trace__sha256_ctx_update ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_1 <- total;
      (result_1, tmp__trace) <@ __sha2_room (param_1);
      trace__sha256_ctx_update <- (trace__sha256_ctx_update ++ tmp__trace);
      room <- result_1;
      status <- (W64.of_int 2);
      ok <- (inlen \ult room);
      if (ok) {
        ms <- (update_msf ok ms);
        b_param_0 <- (SBArray112_32.get_sub32 b_ctx 4);
        param_7 <- (SBArray112_32.get_sub32 ctx 4);
        b_param <- (SBArray112_64.get_sub8 b_ctx 48);
        param_6 <- (SBArray112_64.get_sub8 ctx 48);
        param_5 <- total;
        param_4 <- in_0;
        param_3 <- inlen;
        param_2 <- ms;
        (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha256_absorb_mem (
        param_7, b_param_0, param_6, b_param, param_5, param_4, param_3,
        param_2);
        result_5 <- aux;
        b_result_0 <- aux_0;
        result_4 <- aux_1;
        b_result <- aux_2;
        result_3 <- aux_3;
        result_2 <- aux_4;
        trace__sha256_ctx_update <- (trace__sha256_ctx_update ++ tmp__trace);
        trace__sha256_ctx_update <-
        (trace__sha256_ctx_update ++
        [(Assert,
         (((BArray32.is_init b_result_0 0 32) /\
          (BArray64.is_init b_result 0
          (W64.to_uint (result_3 \umod (W64.of_int 64))))) /\
         (result_3 = (param_5 + param_3))))]);
        b_ctx <-
        (SBArray112_32.set_sub32 b_ctx 4 (BArray32.init_arr (W8.of_int 255)));
        ctx <- (SBArray112_32.set_sub32 ctx 4 result_5);
        b_ctx <- (SBArray112_64.set_sub8 b_ctx 48 b_result);
        ctx <- (SBArray112_64.set_sub8 ctx 48 result_4);
        total <- result_3;
        ms <- result_2;
        b_ctx <-
        (BArray112.set64d b_ctx 8 (W64.of_int 18446744073709551615));
        ctx <- (BArray112.set64d ctx 8 total);
        status <- (W64.of_int 0);
      } else {
        ms <- (update_msf (! ok) ms);
      }
    } else {
      ms <- (update_msf (! ok) ms);
    }
    return (ctx, b_ctx, status, ms, trace__sha256_ctx_update);
  }
  proc _sha512_ctx_update (ctx:BArray208.t, b_ctx:BArray208.t, in_0:W64.t,
                           inlen:W64.t, expect_0:W64.t, ms:W64.t) : BArray208.t *
                                                                    BArray208.t *
                                                                    W64.t *
                                                                    W64.t *
                                                                    trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:W64.t;
    var aux_4:W64.t;
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var room:W64.t;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var result_1:W64.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:W64.t;
    var param_5:W64.t;
    var param_6:BArray128.t;
    var param_7:BArray64.t;
    var result_2:W64.t;
    var result_3:W64.t;
    var result_4:BArray128.t;
    var result_5:BArray64.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray16.t;
    var trace__sha512_ctx_update:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_6 <- witness;
    param_7 <- witness;
    result_4 <- witness;
    result_5 <- witness;
    trace__sha512_ctx_update <- [];
    trace__sha512_ctx_update <-
    (trace__sha512_ctx_update ++
    [(Assert,
     ((BArray208.is_init b_ctx 0 208) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    b_param_1 <- (SBArray208_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray208_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_1,
    param);
    trace__sha512_ctx_update <- (trace__sha512_ctx_update ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_1 <- total;
      (result_1, tmp__trace) <@ __sha2_room (param_1);
      trace__sha512_ctx_update <- (trace__sha512_ctx_update ++ tmp__trace);
      room <- result_1;
      status <- (W64.of_int 2);
      ok <- (inlen \ult room);
      if (ok) {
        ms <- (update_msf ok ms);
        b_param_0 <- (SBArray208_64.get_sub64 b_ctx 2);
        param_7 <- (SBArray208_64.get_sub64 ctx 2);
        b_param <- (SBArray208_128.get_sub8 b_ctx 80);
        param_6 <- (SBArray208_128.get_sub8 ctx 80);
        param_5 <- total;
        param_4 <- in_0;
        param_3 <- inlen;
        param_2 <- ms;
        (aux, aux_0, aux_1, aux_2, aux_3, aux_4, tmp__trace) <@ _sha512_absorb_mem (
        param_7, b_param_0, param_6, b_param, param_5, param_4, param_3,
        param_2);
        result_5 <- aux;
        b_result_0 <- aux_0;
        result_4 <- aux_1;
        b_result <- aux_2;
        result_3 <- aux_3;
        result_2 <- aux_4;
        trace__sha512_ctx_update <- (trace__sha512_ctx_update ++ tmp__trace);
        trace__sha512_ctx_update <-
        (trace__sha512_ctx_update ++
        [(Assert,
         (((BArray64.is_init b_result_0 0 64) /\
          (BArray128.is_init b_result 0
          (W64.to_uint (result_3 \umod (W64.of_int 128))))) /\
         (result_3 = (param_5 + param_3))))]);
        b_ctx <-
        (SBArray208_64.set_sub64 b_ctx 2 (BArray64.init_arr (W8.of_int 255)));
        ctx <- (SBArray208_64.set_sub64 ctx 2 result_5);
        b_ctx <- (SBArray208_128.set_sub8 b_ctx 80 b_result);
        ctx <- (SBArray208_128.set_sub8 ctx 80 result_4);
        total <- result_3;
        ms <- result_2;
        b_ctx <-
        (BArray208.set64d b_ctx 8 (W64.of_int 18446744073709551615));
        ctx <- (BArray208.set64d ctx 8 total);
        status <- (W64.of_int 0);
      } else {
        ms <- (update_msf (! ok) ms);
      }
    } else {
      ms <- (update_msf (! ok) ms);
    }
    return (ctx, b_ctx, status, ms, trace__sha512_ctx_update);
  }
  proc _sha224_ctx____ctx_finalize (ctx:BArray112.t, b_ctx:BArray112.t,
                                    digest:BArray28.t, b_digest:BArray28.t,
                                    total:W64.t, ms:W64.t) : BArray112.t *
                                                             BArray112.t *
                                                             BArray28.t *
                                                             BArray28.t *
                                                             W64.t * trace = {
    var aux:BArray28.t;
    var aux_0:BArray28.t;
    var aux_1:BArray32.t;
    var aux_2:BArray32.t;
    var aux_3:BArray64.t;
    var aux_4:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray64.t;
    var param_2:BArray32.t;
    var param_3:BArray28.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var result_1:BArray32.t;
    var result_2:BArray28.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray28.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_param_1:BArray28.t;
    var trace__sha224_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha224_ctx____ctx_finalize <- [];
    trace__sha224_ctx____ctx_finalize <-
    (trace__sha224_ctx____ctx_finalize ++
    [(Assert, (BArray112.is_init b_ctx 0 112))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray112_32.get_sub32 b_ctx 4);
    param_2 <- (SBArray112_32.get_sub32 ctx 4);
    b_param <- (SBArray112_64.get_sub8 b_ctx 48);
    param_1 <- (SBArray112_64.get_sub8 ctx 48);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha224___sha256_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha224_ctx____ctx_finalize <-
    (trace__sha224_ctx____ctx_finalize ++ tmp__trace);
    trace__sha224_ctx____ctx_finalize <-
    (trace__sha224_ctx____ctx_finalize ++
    [(Assert,
     (((BArray28.is_init b_result_1 0 28) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray112_32.set_sub32 b_ctx 4 (BArray32.init_arr (W8.of_int 255)));
    ctx <- (SBArray112_32.set_sub32 ctx 4 result_1);
    b_ctx <-
    (SBArray112_64.set_sub8 b_ctx 48 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray112_64.set_sub8 ctx 48 result_0);
    ms <- result;
    b_digest <- (BArray28.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha224_ctx____ctx_finalize);
  }
  proc _sha224_ctx___sha2_ctx_final (ctx:BArray112.t, b_ctx:BArray112.t,
                                     digest:BArray28.t, b_digest:BArray28.t,
                                     expect_0:W64.t, ms:W64.t) : BArray112.t *
                                                                 BArray112.t *
                                                                 BArray28.t *
                                                                 BArray28.t *
                                                                 W64.t *
                                                                 W64.t *
                                                                 trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray28.t;
    var param_4:BArray112.t;
    var result_1:W64.t;
    var result_2:BArray28.t;
    var result_3:BArray112.t;
    var b_result:BArray28.t;
    var b_result_0:BArray112.t;
    var b_param:BArray28.t;
    var b_param_0:BArray16.t;
    var trace__sha224_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha224_ctx___sha2_ctx_final <- [];
    trace__sha224_ctx___sha2_ctx_final <-
    (trace__sha224_ctx___sha2_ctx_final ++
    [(Assert, (BArray112.is_init b_ctx 0 112))]);
    b_param_0 <- (SBArray112_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray112_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha224_ctx___sha2_ctx_final <-
    (trace__sha224_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha224_ctx____ctx_finalize (param_4,
      (BArray112.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha224_ctx___sha2_ctx_final <-
      (trace__sha224_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha224_ctx___sha2_ctx_final <-
      (trace__sha224_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray112.is_init b_result_0 0 112) /\
       (BArray28.is_init b_result 0 28)))]);
      ctx <- result_3;
      b_digest <- (BArray28.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 14)) {
        trace__sha224_ctx___sha2_ctx_final <-
        (trace__sha224_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 112)))]);
        ctx <- (BArray112.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray112.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha224_ctx___sha2_ctx_final);
  }
  proc _sha256_ctx____ctx_finalize (ctx:BArray112.t, b_ctx:BArray112.t,
                                    digest:BArray32.t, b_digest:BArray32.t,
                                    total:W64.t, ms:W64.t) : BArray112.t *
                                                             BArray112.t *
                                                             BArray32.t *
                                                             BArray32.t *
                                                             W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray32.t;
    var aux_2:BArray32.t;
    var aux_3:BArray64.t;
    var aux_4:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray64.t;
    var param_2:BArray32.t;
    var param_3:BArray32.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var result_1:BArray32.t;
    var result_2:BArray32.t;
    var b_result:BArray64.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_param_1:BArray32.t;
    var trace__sha256_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha256_ctx____ctx_finalize <- [];
    trace__sha256_ctx____ctx_finalize <-
    (trace__sha256_ctx____ctx_finalize ++
    [(Assert, (BArray112.is_init b_ctx 0 112))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray112_32.get_sub32 b_ctx 4);
    param_2 <- (SBArray112_32.get_sub32 ctx 4);
    b_param <- (SBArray112_64.get_sub8 b_ctx 48);
    param_1 <- (SBArray112_64.get_sub8 ctx 48);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha256___sha256_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha256_ctx____ctx_finalize <-
    (trace__sha256_ctx____ctx_finalize ++ tmp__trace);
    trace__sha256_ctx____ctx_finalize <-
    (trace__sha256_ctx____ctx_finalize ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray112_32.set_sub32 b_ctx 4 (BArray32.init_arr (W8.of_int 255)));
    ctx <- (SBArray112_32.set_sub32 ctx 4 result_1);
    b_ctx <-
    (SBArray112_64.set_sub8 b_ctx 48 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray112_64.set_sub8 ctx 48 result_0);
    ms <- result;
    b_digest <- (BArray32.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha256_ctx____ctx_finalize);
  }
  proc _sha256_ctx___sha2_ctx_final (ctx:BArray112.t, b_ctx:BArray112.t,
                                     digest:BArray32.t, b_digest:BArray32.t,
                                     expect_0:W64.t, ms:W64.t) : BArray112.t *
                                                                 BArray112.t *
                                                                 BArray32.t *
                                                                 BArray32.t *
                                                                 W64.t *
                                                                 W64.t *
                                                                 trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray32.t;
    var param_4:BArray112.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var result_3:BArray112.t;
    var b_result:BArray32.t;
    var b_result_0:BArray112.t;
    var b_param:BArray32.t;
    var b_param_0:BArray16.t;
    var trace__sha256_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha256_ctx___sha2_ctx_final <- [];
    trace__sha256_ctx___sha2_ctx_final <-
    (trace__sha256_ctx___sha2_ctx_final ++
    [(Assert, (BArray112.is_init b_ctx 0 112))]);
    b_param_0 <- (SBArray112_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray112_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha256_ctx___sha2_ctx_final <-
    (trace__sha256_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha256_ctx____ctx_finalize (param_4,
      (BArray112.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha256_ctx___sha2_ctx_final <-
      (trace__sha256_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha256_ctx___sha2_ctx_final <-
      (trace__sha256_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray112.is_init b_result_0 0 112) /\
       (BArray32.is_init b_result 0 32)))]);
      ctx <- result_3;
      b_digest <- (BArray32.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 14)) {
        trace__sha256_ctx___sha2_ctx_final <-
        (trace__sha256_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 112)))]);
        ctx <- (BArray112.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray112.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha256_ctx___sha2_ctx_final);
  }
  proc _sha384_ctx____ctx_finalize (ctx:BArray208.t, b_ctx:BArray208.t,
                                    digest:BArray48.t, b_digest:BArray48.t,
                                    total:W64.t, ms:W64.t) : BArray208.t *
                                                             BArray208.t *
                                                             BArray48.t *
                                                             BArray48.t *
                                                             W64.t * trace = {
    var aux_3:BArray128.t;
    var aux_4:BArray128.t;
    var aux:BArray48.t;
    var aux_0:BArray48.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var param_3:BArray48.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var result_1:BArray64.t;
    var result_2:BArray48.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray48.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray48.t;
    var trace__sha384_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha384_ctx____ctx_finalize <- [];
    trace__sha384_ctx____ctx_finalize <-
    (trace__sha384_ctx____ctx_finalize ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray208_64.get_sub64 b_ctx 2);
    param_2 <- (SBArray208_64.get_sub64 ctx 2);
    b_param <- (SBArray208_128.get_sub8 b_ctx 80);
    param_1 <- (SBArray208_128.get_sub8 ctx 80);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha384___sha512_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha384_ctx____ctx_finalize <-
    (trace__sha384_ctx____ctx_finalize ++ tmp__trace);
    trace__sha384_ctx____ctx_finalize <-
    (trace__sha384_ctx____ctx_finalize ++
    [(Assert,
     (((BArray48.is_init b_result_1 0 48) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray208_64.set_sub64 b_ctx 2 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_64.set_sub64 ctx 2 result_1);
    b_ctx <-
    (SBArray208_128.set_sub8 b_ctx 80 (BArray128.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_128.set_sub8 ctx 80 result_0);
    ms <- result;
    b_digest <- (BArray48.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha384_ctx____ctx_finalize);
  }
  proc _sha384_ctx___sha2_ctx_final (ctx:BArray208.t, b_ctx:BArray208.t,
                                     digest:BArray48.t, b_digest:BArray48.t,
                                     expect_0:W64.t, ms:W64.t) : BArray208.t *
                                                                 BArray208.t *
                                                                 BArray48.t *
                                                                 BArray48.t *
                                                                 W64.t *
                                                                 W64.t *
                                                                 trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray48.t;
    var param_4:BArray208.t;
    var result_1:W64.t;
    var result_2:BArray48.t;
    var result_3:BArray208.t;
    var b_result:BArray48.t;
    var b_result_0:BArray208.t;
    var b_param:BArray48.t;
    var b_param_0:BArray16.t;
    var trace__sha384_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha384_ctx___sha2_ctx_final <- [];
    trace__sha384_ctx___sha2_ctx_final <-
    (trace__sha384_ctx___sha2_ctx_final ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_0 <- (SBArray208_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray208_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha384_ctx___sha2_ctx_final <-
    (trace__sha384_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha384_ctx____ctx_finalize (param_4,
      (BArray208.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha384_ctx___sha2_ctx_final <-
      (trace__sha384_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha384_ctx___sha2_ctx_final <-
      (trace__sha384_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray208.is_init b_result_0 0 208) /\
       (BArray48.is_init b_result 0 48)))]);
      ctx <- result_3;
      b_digest <- (BArray48.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 26)) {
        trace__sha384_ctx___sha2_ctx_final <-
        (trace__sha384_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 208)))]);
        ctx <- (BArray208.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha384_ctx___sha2_ctx_final);
  }
  proc _sha512_ctx____ctx_finalize (ctx:BArray208.t, b_ctx:BArray208.t,
                                    digest:BArray64.t, b_digest:BArray64.t,
                                    total:W64.t, ms:W64.t) : BArray208.t *
                                                             BArray208.t *
                                                             BArray64.t *
                                                             BArray64.t *
                                                             W64.t * trace = {
    var aux_3:BArray128.t;
    var aux_4:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var param_3:BArray64.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var result_1:BArray64.t;
    var result_2:BArray64.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray64.t;
    var trace__sha512_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha512_ctx____ctx_finalize <- [];
    trace__sha512_ctx____ctx_finalize <-
    (trace__sha512_ctx____ctx_finalize ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray208_64.get_sub64 b_ctx 2);
    param_2 <- (SBArray208_64.get_sub64 ctx 2);
    b_param <- (SBArray208_128.get_sub8 b_ctx 80);
    param_1 <- (SBArray208_128.get_sub8 ctx 80);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha512___sha512_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha512_ctx____ctx_finalize <-
    (trace__sha512_ctx____ctx_finalize ++ tmp__trace);
    trace__sha512_ctx____ctx_finalize <-
    (trace__sha512_ctx____ctx_finalize ++
    [(Assert,
     (((BArray64.is_init b_result_1 0 64) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray208_64.set_sub64 b_ctx 2 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_64.set_sub64 ctx 2 result_1);
    b_ctx <-
    (SBArray208_128.set_sub8 b_ctx 80 (BArray128.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_128.set_sub8 ctx 80 result_0);
    ms <- result;
    b_digest <- (BArray64.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha512_ctx____ctx_finalize);
  }
  proc _sha512_ctx___sha2_ctx_final (ctx:BArray208.t, b_ctx:BArray208.t,
                                     digest:BArray64.t, b_digest:BArray64.t,
                                     expect_0:W64.t, ms:W64.t) : BArray208.t *
                                                                 BArray208.t *
                                                                 BArray64.t *
                                                                 BArray64.t *
                                                                 W64.t *
                                                                 W64.t *
                                                                 trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray208.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var result_3:BArray208.t;
    var b_result:BArray64.t;
    var b_result_0:BArray208.t;
    var b_param:BArray64.t;
    var b_param_0:BArray16.t;
    var trace__sha512_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha512_ctx___sha2_ctx_final <- [];
    trace__sha512_ctx___sha2_ctx_final <-
    (trace__sha512_ctx___sha2_ctx_final ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_0 <- (SBArray208_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray208_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha512_ctx___sha2_ctx_final <-
    (trace__sha512_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha512_ctx____ctx_finalize (param_4,
      (BArray208.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha512_ctx___sha2_ctx_final <-
      (trace__sha512_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha512_ctx___sha2_ctx_final <-
      (trace__sha512_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray208.is_init b_result_0 0 208) /\
       (BArray64.is_init b_result 0 64)))]);
      ctx <- result_3;
      b_digest <- (BArray64.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 26)) {
        trace__sha512_ctx___sha2_ctx_final <-
        (trace__sha512_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 208)))]);
        ctx <- (BArray208.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha512_ctx___sha2_ctx_final);
  }
  proc _sha512_224_ctx____ctx_finalize (ctx:BArray208.t, b_ctx:BArray208.t,
                                        digest:BArray28.t,
                                        b_digest:BArray28.t, total:W64.t,
                                        ms:W64.t) : BArray208.t *
                                                    BArray208.t *
                                                    BArray28.t * BArray28.t *
                                                    W64.t * trace = {
    var aux_3:BArray128.t;
    var aux_4:BArray128.t;
    var aux:BArray28.t;
    var aux_0:BArray28.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var param_3:BArray28.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var result_1:BArray64.t;
    var result_2:BArray28.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray28.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray28.t;
    var trace__sha512_224_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha512_224_ctx____ctx_finalize <- [];
    trace__sha512_224_ctx____ctx_finalize <-
    (trace__sha512_224_ctx____ctx_finalize ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray208_64.get_sub64 b_ctx 2);
    param_2 <- (SBArray208_64.get_sub64 ctx 2);
    b_param <- (SBArray208_128.get_sub8 b_ctx 80);
    param_1 <- (SBArray208_128.get_sub8 ctx 80);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha512_224___sha512_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha512_224_ctx____ctx_finalize <-
    (trace__sha512_224_ctx____ctx_finalize ++ tmp__trace);
    trace__sha512_224_ctx____ctx_finalize <-
    (trace__sha512_224_ctx____ctx_finalize ++
    [(Assert,
     (((BArray28.is_init b_result_1 0 28) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray208_64.set_sub64 b_ctx 2 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_64.set_sub64 ctx 2 result_1);
    b_ctx <-
    (SBArray208_128.set_sub8 b_ctx 80 (BArray128.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_128.set_sub8 ctx 80 result_0);
    ms <- result;
    b_digest <- (BArray28.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha512_224_ctx____ctx_finalize);
  }
  proc _sha512_224_ctx___sha2_ctx_final (ctx:BArray208.t, b_ctx:BArray208.t,
                                         digest:BArray28.t,
                                         b_digest:BArray28.t, expect_0:W64.t,
                                         ms:W64.t) : BArray208.t *
                                                     BArray208.t *
                                                     BArray28.t *
                                                     BArray28.t * W64.t *
                                                     W64.t * trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray28.t;
    var param_4:BArray208.t;
    var result_1:W64.t;
    var result_2:BArray28.t;
    var result_3:BArray208.t;
    var b_result:BArray28.t;
    var b_result_0:BArray208.t;
    var b_param:BArray28.t;
    var b_param_0:BArray16.t;
    var trace__sha512_224_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha512_224_ctx___sha2_ctx_final <- [];
    trace__sha512_224_ctx___sha2_ctx_final <-
    (trace__sha512_224_ctx___sha2_ctx_final ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_0 <- (SBArray208_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray208_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha512_224_ctx___sha2_ctx_final <-
    (trace__sha512_224_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha512_224_ctx____ctx_finalize (param_4,
      (BArray208.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha512_224_ctx___sha2_ctx_final <-
      (trace__sha512_224_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha512_224_ctx___sha2_ctx_final <-
      (trace__sha512_224_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray208.is_init b_result_0 0 208) /\
       (BArray28.is_init b_result 0 28)))]);
      ctx <- result_3;
      b_digest <- (BArray28.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 26)) {
        trace__sha512_224_ctx___sha2_ctx_final <-
        (trace__sha512_224_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 208)))]);
        ctx <- (BArray208.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha512_224_ctx___sha2_ctx_final);
  }
  proc _sha512_256_ctx____ctx_finalize (ctx:BArray208.t, b_ctx:BArray208.t,
                                        digest:BArray32.t,
                                        b_digest:BArray32.t, total:W64.t,
                                        ms:W64.t) : BArray208.t *
                                                    BArray208.t *
                                                    BArray32.t * BArray32.t *
                                                    W64.t * trace = {
    var aux_3:BArray128.t;
    var aux_4:BArray128.t;
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:BArray128.t;
    var param_2:BArray64.t;
    var param_3:BArray32.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var result_1:BArray64.t;
    var result_2:BArray32.t;
    var b_result:BArray128.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray32.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray32.t;
    var trace__sha512_256_ctx____ctx_finalize:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    param_1 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_0 <- witness;
    result_1 <- witness;
    result_2 <- witness;
    trace__sha512_256_ctx____ctx_finalize <- [];
    trace__sha512_256_ctx____ctx_finalize <-
    (trace__sha512_256_ctx____ctx_finalize ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_1 <- b_digest;
    param_3 <- digest;
    b_param_0 <- (SBArray208_64.get_sub64 b_ctx 2);
    param_2 <- (SBArray208_64.get_sub64 ctx 2);
    b_param <- (SBArray208_128.get_sub8 b_ctx 80);
    param_1 <- (SBArray208_128.get_sub8 ctx 80);
    param_0 <- total;
    param <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, aux_4, aux_5, tmp__trace) <@ _sha512_256___sha512_finalize (
    param_3, b_param_1, param_2, b_param_0, param_1, b_param, param_0,
    param);
    result_2 <- aux;
    b_result_1 <- aux_0;
    result_1 <- aux_1;
    b_result_0 <- aux_2;
    result_0 <- aux_3;
    b_result <- aux_4;
    result <- aux_5;
    trace__sha512_256_ctx____ctx_finalize <-
    (trace__sha512_256_ctx____ctx_finalize ++ tmp__trace);
    trace__sha512_256_ctx____ctx_finalize <-
    (trace__sha512_256_ctx____ctx_finalize ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    digest <- result_2;
    b_ctx <-
    (SBArray208_64.set_sub64 b_ctx 2 (BArray64.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_64.set_sub64 ctx 2 result_1);
    b_ctx <-
    (SBArray208_128.set_sub8 b_ctx 80 (BArray128.init_arr (W8.of_int 255)));
    ctx <- (SBArray208_128.set_sub8 ctx 80 result_0);
    ms <- result;
    b_digest <- (BArray32.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, ms,
           trace__sha512_256_ctx____ctx_finalize);
  }
  proc _sha512_256_ctx___sha2_ctx_final (ctx:BArray208.t, b_ctx:BArray208.t,
                                         digest:BArray32.t,
                                         b_digest:BArray32.t, expect_0:W64.t,
                                         ms:W64.t) : BArray208.t *
                                                     BArray208.t *
                                                     BArray32.t *
                                                     BArray32.t * W64.t *
                                                     W64.t * trace = {
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var ok:bool;
    var z:W64.t;
    var i:int;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray32.t;
    var param_4:BArray208.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var result_3:BArray208.t;
    var b_result:BArray32.t;
    var b_result_0:BArray208.t;
    var b_param:BArray32.t;
    var b_param_0:BArray16.t;
    var trace__sha512_256_ctx___sha2_ctx_final:trace;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_0 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace__sha512_256_ctx___sha2_ctx_final <- [];
    trace__sha512_256_ctx___sha2_ctx_final <-
    (trace__sha512_256_ctx___sha2_ctx_final ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    b_param_0 <- (SBArray208_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray208_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_0,
    param);
    trace__sha512_256_ctx___sha2_ctx_final <-
    (trace__sha512_256_ctx___sha2_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      param_4 <- ctx;
      b_param <- b_digest;
      param_3 <- digest;
      param_2 <- total;
      param_1 <- ms;
      (result_3, b_result_0, result_2, b_result, result_1, tmp__trace) <@ 
      _sha512_256_ctx____ctx_finalize (param_4,
      (BArray208.init_arr (W8.of_int 255)), param_3, b_param, param_2,
      param_1);
      trace__sha512_256_ctx___sha2_ctx_final <-
      (trace__sha512_256_ctx___sha2_ctx_final ++ tmp__trace);
      trace__sha512_256_ctx___sha2_ctx_final <-
      (trace__sha512_256_ctx___sha2_ctx_final ++
      [(Assert,
       ((BArray208.is_init b_result_0 0 208) /\
       (BArray32.is_init b_result 0 32)))]);
      ctx <- result_3;
      b_digest <- (BArray32.init_arr (W8.of_int 255));
      digest <- result_2;
      ms <- result_1;
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 26)) {
        trace__sha512_256_ctx___sha2_ctx_final <-
        (trace__sha512_256_ctx___sha2_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 208)))]);
        ctx <- (BArray208.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, digest, b_digest, status, ms,
           trace__sha512_256_ctx___sha2_ctx_final);
  }
  proc __hmac_sha256_ctx_init (ctx:BArray144.t, b_ctx:BArray144.t, key:W64.t,
                               keylen:W64.t, ms:W64.t) : BArray144.t *
                                                         BArray144.t *
                                                         W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray32.t;
    var aux_2:BArray32.t;
    var aux_3:W64.t;
    var k0:BArray64.t;
    var inner:BArray32.t;
    var outer:BArray32.t;
    var tag:W64.t;
    var total:W64.t;
    var i:int;
    var x:W32.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_3:W64.t;
    var param_4:BArray64.t;
    var param_5:BArray32.t;
    var param_6:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var result_3:BArray32.t;
    var param_7:int;
    var result_4:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:BArray32.t;
    var param_11:BArray112.t;
    var result_5:BArray112.t;
    var b_outer:BArray32.t;
    var b_result:BArray112.t;
    var b_param:BArray112.t;
    var b_inner:BArray32.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param_0:BArray32.t;
    var b_param_1:BArray32.t;
    var b_k0:BArray64.t;
    var b_result_2:BArray64.t;
    var b_param_2:BArray64.t;
    var trace___hmac_sha256_ctx_init:trace;
    b_inner <- witness;
    b_k0 <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    inner <- witness;
    k0 <- witness;
    outer <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_10 <- witness;
    param_11 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    trace___hmac_sha256_ctx_init <- [];
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)))]);
    b_k0 <- (BArray64.init_arr (W8.of_int 0));
    b_inner <- (BArray32.init_arr (W8.of_int 0));
    b_outer <- (BArray32.init_arr (W8.of_int 0));
    (* Erased call to spill *)
    b_param_2 <- b_k0;
    param_2 <- k0;
    param_1 <- key;
    param_0 <- keylen;
    param <- ms;
    (result_0, b_result_2, result, tmp__trace) <@ _hmac_sha256_keyblock_mem (
    param_2, b_param_2, param_1, param_0, param);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++ tmp__trace);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++
    [(Assert, (BArray64.is_init b_result_2 0 64))]);
    k0 <- result_0;
    ms <- result;
    b_param_1 <- b_inner;
    param_6 <- inner;
    b_param_0 <- b_outer;
    param_5 <- outer;
    param_4 <- k0;
    param_3 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ __hmac_sha256_init (
    param_6, b_param_1, param_5, b_param_0, param_4,
    (BArray64.init_arr (W8.of_int 255)), param_3);
    result_3 <- aux;
    b_result_1 <- aux_0;
    result_2 <- aux_1;
    b_result_0 <- aux_2;
    result_1 <- aux_3;
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++ tmp__trace);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++
    [(Assert,
     ((BArray32.is_init b_result_1 0 32) /\
     (BArray32.is_init b_result_0 0 32)))]);
    inner <- result_3;
    outer <- result_2;
    ms <- result_1;
    (* Erased call to unspill *)
    b_ctx <- b_ctx;
    ctx <- (protect_ptr ctx ms);
    param_7 <- 7;
    (result_4, tmp__trace) <@ __sha2_tag (param_7);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++ tmp__trace);
    tag <- result_4;
    total <- (W64.of_int 64);
    b_param <- (SBArray144_112.get_sub8 b_ctx 0);
    param_11 <- (SBArray144_112.get_sub8 ctx 0);
    param_10 <- inner;
    param_9 <- tag;
    param_8 <- total;
    (result_5, b_result, tmp__trace) <@ __sha256_ctx_init (param_11, 
    b_param, param_10, (BArray32.init_arr (W8.of_int 255)), param_9,
    param_8);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++ tmp__trace);
    trace___hmac_sha256_ctx_init <-
    (trace___hmac_sha256_ctx_init ++
    [(Assert, (BArray112.is_init b_result 0 112))]);
    b_ctx <-
    (SBArray144_112.set_sub8 b_ctx 0 (BArray112.init_arr (W8.of_int 255)));
    ctx <- (SBArray144_112.set_sub8 ctx 0 result_5);
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha256_ctx_init <-
      (trace___hmac_sha256_ctx_init ++
      [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
      x <- (BArray32.get32 outer i);
      trace___hmac_sha256_ctx_init <-
      (trace___hmac_sha256_ctx_init ++
      [(Assert, ((0 <= (112 + (4 * i))) /\ (((112 + (4 * i)) + 4) <= 144)))]);
      b_ctx <-
      (BArray144.set32d b_ctx (112 + (4 * i)) (W32.of_int 4294967295));
      ctx <- (BArray144.set32d ctx (112 + (4 * i)) x);
      i <- (i + 1);
    }
    return (ctx, b_ctx, ms, trace___hmac_sha256_ctx_init);
  }
  proc __hmac_sha512_ctx_init (ctx:BArray272.t, b_ctx:BArray272.t, key:W64.t,
                               keylen:W64.t, ms:W64.t) : BArray272.t *
                                                         BArray272.t *
                                                         W64.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var k0:BArray128.t;
    var inner:BArray64.t;
    var outer:BArray64.t;
    var tag:W64.t;
    var total:W64.t;
    var i:int;
    var t:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var param_6:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var result_3:BArray64.t;
    var param_7:int;
    var result_4:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:BArray64.t;
    var param_11:BArray208.t;
    var result_5:BArray208.t;
    var b_outer:BArray64.t;
    var b_result:BArray208.t;
    var b_param:BArray208.t;
    var b_inner:BArray64.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param_0:BArray64.t;
    var b_param_1:BArray64.t;
    var b_k0:BArray128.t;
    var b_result_2:BArray128.t;
    var b_param_2:BArray128.t;
    var trace___hmac_sha512_ctx_init:trace;
    b_inner <- witness;
    b_k0 <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    inner <- witness;
    k0 <- witness;
    outer <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_10 <- witness;
    param_11 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    trace___hmac_sha512_ctx_init <- [];
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)))]);
    b_k0 <- (BArray128.init_arr (W8.of_int 0));
    b_inner <- (BArray64.init_arr (W8.of_int 0));
    b_outer <- (BArray64.init_arr (W8.of_int 0));
    (* Erased call to spill *)
    b_param_2 <- b_k0;
    param_2 <- k0;
    param_1 <- key;
    param_0 <- keylen;
    param <- ms;
    (result_0, b_result_2, result, tmp__trace) <@ _hmac_sha512_keyblock_mem (
    param_2, b_param_2, param_1, param_0, param);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++ tmp__trace);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++
    [(Assert, (BArray128.is_init b_result_2 0 128))]);
    k0 <- result_0;
    ms <- result;
    b_param_1 <- b_inner;
    param_6 <- inner;
    b_param_0 <- b_outer;
    param_5 <- outer;
    param_4 <- k0;
    param_3 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ __hmac_sha512_init (
    param_6, b_param_1, param_5, b_param_0, param_4,
    (BArray128.init_arr (W8.of_int 255)), param_3);
    result_3 <- aux;
    b_result_1 <- aux_0;
    result_2 <- aux_1;
    b_result_0 <- aux_2;
    result_1 <- aux_3;
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++ tmp__trace);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++
    [(Assert,
     ((BArray64.is_init b_result_1 0 64) /\
     (BArray64.is_init b_result_0 0 64)))]);
    inner <- result_3;
    outer <- result_2;
    ms <- result_1;
    (* Erased call to unspill *)
    b_ctx <- b_ctx;
    ctx <- (protect_ptr ctx ms);
    param_7 <- 8;
    (result_4, tmp__trace) <@ __sha2_tag (param_7);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++ tmp__trace);
    tag <- result_4;
    total <- (W64.of_int 128);
    b_param <- (SBArray272_208.get_sub8 b_ctx 0);
    param_11 <- (SBArray272_208.get_sub8 ctx 0);
    param_10 <- inner;
    param_9 <- tag;
    param_8 <- total;
    (result_5, b_result, tmp__trace) <@ __sha512_ctx_init (param_11, 
    b_param, param_10, (BArray64.init_arr (W8.of_int 255)), param_9,
    param_8);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++ tmp__trace);
    trace___hmac_sha512_ctx_init <-
    (trace___hmac_sha512_ctx_init ++
    [(Assert, (BArray208.is_init b_result 0 208))]);
    b_ctx <-
    (SBArray272_208.set_sub8 b_ctx 0 (BArray208.init_arr (W8.of_int 255)));
    ctx <- (SBArray272_208.set_sub8 ctx 0 result_5);
    i <- 0;
    while ((i < 8)) {
      trace___hmac_sha512_ctx_init <-
      (trace___hmac_sha512_ctx_init ++
      [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
      t <- (BArray64.get64 outer i);
      trace___hmac_sha512_ctx_init <-
      (trace___hmac_sha512_ctx_init ++
      [(Assert, ((0 <= (208 + (8 * i))) /\ (((208 + (8 * i)) + 8) <= 272)))]);
      b_ctx <-
      (BArray272.set64d b_ctx (208 + (8 * i))
      (W64.of_int 18446744073709551615));
      ctx <- (BArray272.set64d ctx (208 + (8 * i)) t);
      i <- (i + 1);
    }
    return (ctx, b_ctx, ms, trace___hmac_sha512_ctx_init);
  }
  proc __hmac_sha256_ctx_final (ctx:BArray144.t, b_ctx:BArray144.t,
                                out:BArray32.t, b_out:BArray32.t, ms:W64.t) : 
  BArray144.t * BArray144.t * BArray32.t * BArray32.t * W64.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_3:BArray32.t;
    var aux_4:BArray32.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_5:W64.t;
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var expect_0:W64.t;
    var ok:bool;
    var inner:BArray32.t;
    var buf:BArray64.t;
    var i:int;
    var x:W32.t;
    var outer:BArray32.t;
    var mac:BArray32.t;
    var t:W64.t;
    var z:W64.t;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:int;
    var result_1:W64.t;
    var param_2:BArray112.t;
    var param_3:BArray64.t;
    var param_4:BArray32.t;
    var result_2:BArray64.t;
    var result_3:BArray32.t;
    var param_5:W64.t;
    var param_6:BArray32.t;
    var param_7:W64.t;
    var param_8:BArray64.t;
    var param_9:BArray32.t;
    var param_10:BArray32.t;
    var result_4:W64.t;
    var result_5:BArray64.t;
    var result_6:BArray32.t;
    var result_7:BArray32.t;
    var b_mac:BArray32.t;
    var b_buf:BArray64.t;
    var b_result:BArray64.t;
    var b_inner:BArray32.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray32.t;
    var b_param_0:BArray32.t;
    var b_outer:BArray32.t;
    var b_result_2:BArray64.t;
    var b_result_3:BArray32.t;
    var b_param_1:BArray112.t;
    var b_param_2:BArray64.t;
    var b_param_3:BArray32.t;
    var b_param_4:BArray16.t;
    var trace___hmac_sha256_ctx_final:trace;
    b_buf <- witness;
    b_inner <- witness;
    b_mac <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_param_3 <- witness;
    b_param_4 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    inner <- witness;
    mac <- witness;
    outer <- witness;
    param_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_6 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    param_10 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    result_7 <- witness;
    trace___hmac_sha256_ctx_final <- [];
    trace___hmac_sha256_ctx_final <-
    (trace___hmac_sha256_ctx_final ++
    [(Assert, (BArray144.is_init b_ctx 0 144))]);
    b_mac <- (BArray32.init_arr (W8.of_int 0));
    b_buf <- (BArray64.init_arr (W8.of_int 0));
    b_inner <- (BArray32.init_arr (W8.of_int 0));
    b_outer <- (BArray32.init_arr (W8.of_int 0));
    b_param_4 <- (SBArray144_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray144_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_4,
    param);
    trace___hmac_sha256_ctx_final <-
    (trace___hmac_sha256_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    param_1 <- 7;
    (result_1, tmp__trace) <@ __sha2_tag (param_1);
    trace___hmac_sha256_ctx_final <-
    (trace___hmac_sha256_ctx_final ++ tmp__trace);
    expect_0 <- result_1;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      b_param_3 <- b_inner;
      param_4 <- inner;
      b_param_2 <- b_buf;
      param_3 <- buf;
      b_param_1 <- (SBArray144_112.get_sub8 b_ctx 0);
      param_2 <- (SBArray144_112.get_sub8 ctx 0);
      (aux, aux_0, aux_1, aux_2, tmp__trace) <@ __sha256_ctx_load (param_4,
      b_param_3, param_3, b_param_2, param_2, b_param_1);
      result_3 <- aux;
      b_result_3 <- aux_0;
      result_2 <- aux_1;
      b_result_2 <- aux_2;
      trace___hmac_sha256_ctx_final <-
      (trace___hmac_sha256_ctx_final ++ tmp__trace);
      trace___hmac_sha256_ctx_final <-
      (trace___hmac_sha256_ctx_final ++
      [(Assert,
       ((BArray32.is_init b_result_3 0 32) /\
       (BArray64.is_init b_result_2 0 64)))]);
      inner <- result_3;
      buf <- result_2;
      i <- 0;
      while ((i < 8)) {
        trace___hmac_sha256_ctx_final <-
        (trace___hmac_sha256_ctx_final ++
        [(Assert, ((0 <= (112 + (4 * i))) /\ (((112 + (4 * i)) + 4) <= 144)))]);
        x <- (BArray144.get32d ctx (112 + (4 * i)));
        trace___hmac_sha256_ctx_final <-
        (trace___hmac_sha256_ctx_final ++
        [(Assert, ((0 <= (i * 4)) /\ (((i * 4) + 4) <= 32)))]);
        b_outer <- (BArray32.set32d b_outer (i * 4) (W32.of_int 4294967295));
        outer <- (BArray32.set32 outer i x);
        i <- (i + 1);
      }
      (* Erased call to spill *)
      b_param_0 <- b_mac;
      param_10 <- mac;
      param_9 <- inner;
      param_8 <- buf;
      param_7 <- total;
      b_param <- b_outer;
      param_6 <- outer;
      param_5 <- ms;
      (aux, aux_0, aux_3, aux_4, aux_1, aux_2, aux_5, tmp__trace) <@ 
      __hmac_sha256_finalize (param_10, b_param_0, param_9,
      (BArray32.init_arr (W8.of_int 255)), param_8,
      (BArray64.init_arr (W8.of_int 255)), param_7, param_6, b_param,
      param_5);
      result_7 <- aux;
      b_result_1 <- aux_0;
      result_6 <- aux_3;
      b_result_0 <- aux_4;
      result_5 <- aux_1;
      b_result <- aux_2;
      result_4 <- aux_5;
      trace___hmac_sha256_ctx_final <-
      (trace___hmac_sha256_ctx_final ++ tmp__trace);
      trace___hmac_sha256_ctx_final <-
      (trace___hmac_sha256_ctx_final ++
      [(Assert, (BArray32.is_init b_result_1 0 32))]);
      mac <- result_7;
      ms <- result_4;
      (* Erased call to unspill *)
      ctx <- (protect_ptr ctx ms);
      b_out <- b_out;
      out <- (protect_ptr out ms);
      i <- 0;
      while ((i < 4)) {
        trace___hmac_sha256_ctx_final <-
        (trace___hmac_sha256_ctx_final ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 32)))]);
        t <- (BArray32.get64 mac i);
        trace___hmac_sha256_ctx_final <-
        (trace___hmac_sha256_ctx_final ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 32)))]);
        b_out <-
        (BArray32.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
        out <- (BArray32.set64 out i t);
        i <- (i + 1);
      }
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 18)) {
        trace___hmac_sha256_ctx_final <-
        (trace___hmac_sha256_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 144)))]);
        ctx <- (BArray144.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray144.init_arr (W8.of_int 255));
    return (ctx, b_ctx, out, b_out, status, ms,
           trace___hmac_sha256_ctx_final);
  }
  proc __hmac_sha512_ctx_final (ctx:BArray272.t, b_ctx:BArray272.t,
                                out:BArray64.t, b_out:BArray64.t, ms:W64.t) : 
  BArray272.t * BArray272.t * BArray64.t * BArray64.t * W64.t * W64.t * trace = {
    var aux_1:BArray128.t;
    var aux_2:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_3:BArray64.t;
    var aux_4:BArray64.t;
    var aux_5:W64.t;
    var status:W64.t;
    var tag:W64.t;
    var total:W64.t;
    var expect_0:W64.t;
    var ok:bool;
    var inner:BArray64.t;
    var buf:BArray128.t;
    var i:int;
    var t:W64.t;
    var outer:BArray64.t;
    var mac:BArray64.t;
    var z:W64.t;
    var param:W64.t;
    var param_0:BArray16.t;
    var result:W64.t;
    var result_0:W64.t;
    var param_1:int;
    var result_1:W64.t;
    var param_2:BArray208.t;
    var param_3:BArray128.t;
    var param_4:BArray64.t;
    var result_2:BArray128.t;
    var result_3:BArray64.t;
    var param_5:W64.t;
    var param_6:BArray64.t;
    var param_7:W64.t;
    var param_8:BArray128.t;
    var param_9:BArray64.t;
    var param_10:BArray64.t;
    var result_4:W64.t;
    var result_5:BArray128.t;
    var result_6:BArray64.t;
    var result_7:BArray64.t;
    var b_mac:BArray64.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_inner:BArray64.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray64.t;
    var b_param_0:BArray64.t;
    var b_outer:BArray64.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray208.t;
    var b_param_2:BArray128.t;
    var b_param_3:BArray64.t;
    var b_param_4:BArray16.t;
    var trace___hmac_sha512_ctx_final:trace;
    b_buf <- witness;
    b_inner <- witness;
    b_mac <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_param_3 <- witness;
    b_param_4 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    buf <- witness;
    inner <- witness;
    mac <- witness;
    outer <- witness;
    param_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    param_4 <- witness;
    param_6 <- witness;
    param_8 <- witness;
    param_9 <- witness;
    param_10 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_5 <- witness;
    result_6 <- witness;
    result_7 <- witness;
    trace___hmac_sha512_ctx_final <- [];
    trace___hmac_sha512_ctx_final <-
    (trace___hmac_sha512_ctx_final ++
    [(Assert, (BArray272.is_init b_ctx 0 272))]);
    b_mac <- (BArray64.init_arr (W8.of_int 0));
    b_buf <- (BArray128.init_arr (W8.of_int 0));
    b_inner <- (BArray64.init_arr (W8.of_int 0));
    b_outer <- (BArray64.init_arr (W8.of_int 0));
    b_param_4 <- (SBArray272_16.get_sub8 b_ctx 0);
    param_0 <- (SBArray272_16.get_sub8 ctx 0);
    param <- ms;
    (result_0, result, tmp__trace) <@ __sha2_ctx_open (param_0, b_param_4,
    param);
    trace___hmac_sha512_ctx_final <-
    (trace___hmac_sha512_ctx_final ++ tmp__trace);
    tag <- result_0;
    total <- result;
    param_1 <- 8;
    (result_1, tmp__trace) <@ __sha2_tag (param_1);
    trace___hmac_sha512_ctx_final <-
    (trace___hmac_sha512_ctx_final ++ tmp__trace);
    expect_0 <- result_1;
    status <- (W64.of_int 1);
    ok <- (tag = expect_0);
    if (ok) {
      ms <- (update_msf ok ms);
      b_param_3 <- b_inner;
      param_4 <- inner;
      b_param_2 <- b_buf;
      param_3 <- buf;
      b_param_1 <- (SBArray272_208.get_sub8 b_ctx 0);
      param_2 <- (SBArray272_208.get_sub8 ctx 0);
      (aux, aux_0, aux_1, aux_2, tmp__trace) <@ __sha512_ctx_load (param_4,
      b_param_3, param_3, b_param_2, param_2, b_param_1);
      result_3 <- aux;
      b_result_3 <- aux_0;
      result_2 <- aux_1;
      b_result_2 <- aux_2;
      trace___hmac_sha512_ctx_final <-
      (trace___hmac_sha512_ctx_final ++ tmp__trace);
      trace___hmac_sha512_ctx_final <-
      (trace___hmac_sha512_ctx_final ++
      [(Assert,
       ((BArray64.is_init b_result_3 0 64) /\
       (BArray128.is_init b_result_2 0 128)))]);
      inner <- result_3;
      buf <- result_2;
      i <- 0;
      while ((i < 8)) {
        trace___hmac_sha512_ctx_final <-
        (trace___hmac_sha512_ctx_final ++
        [(Assert, ((0 <= (208 + (8 * i))) /\ (((208 + (8 * i)) + 8) <= 272)))]);
        t <- (BArray272.get64d ctx (208 + (8 * i)));
        trace___hmac_sha512_ctx_final <-
        (trace___hmac_sha512_ctx_final ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        b_outer <-
        (BArray64.set64d b_outer (i * 8) (W64.of_int 18446744073709551615));
        outer <- (BArray64.set64 outer i t);
        i <- (i + 1);
      }
      (* Erased call to spill *)
      b_param_0 <- b_mac;
      param_10 <- mac;
      param_9 <- inner;
      param_8 <- buf;
      param_7 <- total;
      b_param <- b_outer;
      param_6 <- outer;
      param_5 <- ms;
      (aux, aux_0, aux_3, aux_4, aux_1, aux_2, aux_5, tmp__trace) <@ 
      __hmac_sha512_finalize (param_10, b_param_0, param_9,
      (BArray64.init_arr (W8.of_int 255)), param_8,
      (BArray128.init_arr (W8.of_int 255)), param_7, param_6, b_param,
      param_5);
      result_7 <- aux;
      b_result_1 <- aux_0;
      result_6 <- aux_3;
      b_result_0 <- aux_4;
      result_5 <- aux_1;
      b_result <- aux_2;
      result_4 <- aux_5;
      trace___hmac_sha512_ctx_final <-
      (trace___hmac_sha512_ctx_final ++ tmp__trace);
      trace___hmac_sha512_ctx_final <-
      (trace___hmac_sha512_ctx_final ++
      [(Assert, (BArray64.is_init b_result_1 0 64))]);
      mac <- result_7;
      ms <- result_4;
      (* Erased call to unspill *)
      ctx <- (protect_ptr ctx ms);
      b_out <- b_out;
      out <- (protect_ptr out ms);
      i <- 0;
      while ((i < 8)) {
        trace___hmac_sha512_ctx_final <-
        (trace___hmac_sha512_ctx_final ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        t <- (BArray64.get64 mac i);
        trace___hmac_sha512_ctx_final <-
        (trace___hmac_sha512_ctx_final ++
        [(Assert, ((0 <= (i * 8)) /\ (((i * 8) + 8) <= 64)))]);
        b_out <-
        (BArray64.set64d b_out (i * 8) (W64.of_int 18446744073709551615));
        out <- (BArray64.set64 out i t);
        i <- (i + 1);
      }
      z <- (W64.of_int 0);
      i <- 0;
      while ((i < 34)) {
        trace___hmac_sha512_ctx_final <-
        (trace___hmac_sha512_ctx_final ++
        [(Assert, ((0 <= (8 * i)) /\ (((8 * i) + 8) <= 272)))]);
        ctx <- (BArray272.set64d ctx (8 * i) z);
        i <- (i + 1);
      }
      status <- (W64.of_int 0);
    } else {
      ms <- (update_msf (! ok) ms);
    }
    b_ctx <- (BArray272.init_arr (W8.of_int 255));
    return (ctx, b_ctx, out, b_out, status, ms,
           trace___hmac_sha512_ctx_final);
  }
  proc jade_hash_sha256_amd64_avx2 (out:BArray32.t, b_out:BArray32.t,
                                    in_0:W64.t, inlen:W64.t) : BArray32.t *
                                                               BArray32.t *
                                                               trace = {
    var ms:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray32.t;
    var result:W64.t;
    var result_0:BArray32.t;
    var b_result:BArray32.t;
    var b_param:BArray32.t;
    var trace_jade_hash_sha256_amd64_avx2:trace;
    b_param <- witness;
    b_result <- witness;
    param_2 <- witness;
    result_0 <- witness;
    trace_jade_hash_sha256_amd64_avx2 <- [];
    trace_jade_hash_sha256_amd64_avx2 <-
    (trace_jade_hash_sha256_amd64_avx2 ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    ms <- (init_msf);
    b_param <- b_out;
    param_2 <- out;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (result_0, b_result, result, tmp__trace) <@ _sha256_mem (param_2,
    b_param, param_1, param_0, param);
    trace_jade_hash_sha256_amd64_avx2 <-
    (trace_jade_hash_sha256_amd64_avx2 ++ tmp__trace);
    trace_jade_hash_sha256_amd64_avx2 <-
    (trace_jade_hash_sha256_amd64_avx2 ++
    [(Assert, (BArray32.is_init b_result 0 32))]);
    out <- result_0;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, trace_jade_hash_sha256_amd64_avx2);
  }
  proc jade_hash_sha256_amd64_avx2_init (ctx:BArray112.t, b_ctx:BArray112.t) : 
  BArray112.t * BArray112.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var ms:W64.t;
    var h:BArray32.t;
    var tag:W64.t;
    var total:W64.t;
    var param:BArray32.t;
    var result:BArray32.t;
    var param_0:int;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray32.t;
    var param_4:BArray112.t;
    var result_1:BArray112.t;
    var b_result:BArray112.t;
    var b_param:BArray112.t;
    var b_h:BArray32.t;
    var b_result_0:BArray32.t;
    var b_param_0:BArray32.t;
    var trace_jade_hash_sha256_amd64_avx2_init:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace_jade_hash_sha256_amd64_avx2_init <- [];
    b_h <- (BArray32.init_arr (W8.of_int 0));
    ms <- (init_msf);
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha256_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace_jade_hash_sha256_amd64_avx2_init <-
    (trace_jade_hash_sha256_amd64_avx2_init ++ tmp__trace);
    trace_jade_hash_sha256_amd64_avx2_init <-
    (trace_jade_hash_sha256_amd64_avx2_init ++
    [(Assert, (BArray32.is_init b_result_0 0 32))]);
    h <- result;
    param_0 <- 2;
    (result_0, tmp__trace) <@ __sha2_tag (param_0);
    trace_jade_hash_sha256_amd64_avx2_init <-
    (trace_jade_hash_sha256_amd64_avx2_init ++ tmp__trace);
    tag <- result_0;
    total <- (W64.of_int 0);
    b_param <- b_ctx;
    param_4 <- ctx;
    param_3 <- h;
    param_2 <- tag;
    param_1 <- total;
    (result_1, b_result, tmp__trace) <@ __sha256_ctx_init (param_4, b_param,
    param_3, (BArray32.init_arr (W8.of_int 255)), param_2, param_1);
    trace_jade_hash_sha256_amd64_avx2_init <-
    (trace_jade_hash_sha256_amd64_avx2_init ++ tmp__trace);
    trace_jade_hash_sha256_amd64_avx2_init <-
    (trace_jade_hash_sha256_amd64_avx2_init ++
    [(Assert, (BArray112.is_init b_result 0 112))]);
    ctx <- result_1;
    b_ctx <- (BArray112.init_arr (W8.of_int 255));
    return (ctx, b_ctx, trace_jade_hash_sha256_amd64_avx2_init);
  }
  proc jade_hash_sha256_amd64_avx2_update (ctx:BArray112.t,
                                           b_ctx:BArray112.t, in_0:W64.t,
                                           inlen:W64.t) : BArray112.t *
                                                          BArray112.t *
                                                          W64.t * trace = {
    var status:W64.t;
    var ms:W64.t;
    var expect_0:W64.t;
    var param:int;
    var result:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:BArray112.t;
    var result_0:W64.t;
    var result_1:W64.t;
    var result_2:BArray112.t;
    var b_result:BArray112.t;
    var trace_jade_hash_sha256_amd64_avx2_update:trace;
    b_result <- witness;
    param_4 <- witness;
    result_2 <- witness;
    trace_jade_hash_sha256_amd64_avx2_update <- [];
    trace_jade_hash_sha256_amd64_avx2_update <-
    (trace_jade_hash_sha256_amd64_avx2_update ++
    [(Assert,
     ((BArray112.is_init b_ctx 0 112) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    ms <- (init_msf);
    param <- 2;
    (result, tmp__trace) <@ __sha2_tag (param);
    trace_jade_hash_sha256_amd64_avx2_update <-
    (trace_jade_hash_sha256_amd64_avx2_update ++ tmp__trace);
    expect_0 <- result;
    param_4 <- ctx;
    param_3 <- in_0;
    param_2 <- inlen;
    param_1 <- expect_0;
    param_0 <- ms;
    (result_2, b_result, result_1, result_0, tmp__trace) <@ _sha256_ctx_update (
    param_4, (BArray112.init_arr (W8.of_int 255)), param_3, param_2, 
    param_1, param_0);
    trace_jade_hash_sha256_amd64_avx2_update <-
    (trace_jade_hash_sha256_amd64_avx2_update ++ tmp__trace);
    trace_jade_hash_sha256_amd64_avx2_update <-
    (trace_jade_hash_sha256_amd64_avx2_update ++
    [(Assert, (BArray112.is_init b_result 0 112))]);
    ctx <- result_2;
    status <- result_1;
    b_ctx <- (BArray112.init_arr (W8.of_int 255));
    return (ctx, b_ctx, status, trace_jade_hash_sha256_amd64_avx2_update);
  }
  proc jade_hash_sha256_amd64_avx2_final (ctx:BArray112.t, b_ctx:BArray112.t,
                                          out:BArray32.t, b_out:BArray32.t) : 
  BArray112.t * BArray112.t * BArray32.t * BArray32.t * W64.t * trace = {
    var status:W64.t;
    var ms:W64.t;
    var expect_0:W64.t;
    var param:int;
    var result:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray32.t;
    var param_3:BArray112.t;
    var result_0:W64.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var result_3:BArray112.t;
    var b_result:BArray32.t;
    var b_result_0:BArray112.t;
    var b_param:BArray32.t;
    var trace_jade_hash_sha256_amd64_avx2_final:trace;
    b_param <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace_jade_hash_sha256_amd64_avx2_final <- [];
    trace_jade_hash_sha256_amd64_avx2_final <-
    (trace_jade_hash_sha256_amd64_avx2_final ++
    [(Assert, (BArray112.is_init b_ctx 0 112))]);
    ms <- (init_msf);
    param <- 2;
    (result, tmp__trace) <@ __sha2_tag (param);
    trace_jade_hash_sha256_amd64_avx2_final <-
    (trace_jade_hash_sha256_amd64_avx2_final ++ tmp__trace);
    expect_0 <- result;
    param_3 <- ctx;
    b_param <- b_out;
    param_2 <- out;
    param_1 <- expect_0;
    param_0 <- ms;
    (result_3, b_result_0, result_2, b_result, result_1, result_0,
    tmp__trace) <@ _sha256_ctx___sha2_ctx_final (param_3,
    (BArray112.init_arr (W8.of_int 255)), param_2, b_param, param_1,
    param_0);
    trace_jade_hash_sha256_amd64_avx2_final <-
    (trace_jade_hash_sha256_amd64_avx2_final ++ tmp__trace);
    trace_jade_hash_sha256_amd64_avx2_final <-
    (trace_jade_hash_sha256_amd64_avx2_final ++
    [(Assert,
     ((BArray112.is_init b_result_0 0 112) /\
     (BArray32.is_init b_result 0 ((result_1 = (W64.of_int 0)) ? 32 : 0))))]);
    ctx <- result_3;
    b_out <- b_result;
    out <- result_2;
    status <- result_1;
    b_ctx <- (BArray112.init_arr (W8.of_int 255));
    return (ctx, b_ctx, out, b_out, status,
           trace_jade_hash_sha256_amd64_avx2_final);
  }
  proc jade_hash_sha512_amd64_avx2 (out:BArray64.t, b_out:BArray64.t,
                                    in_0:W64.t, inlen:W64.t) : BArray64.t *
                                                               BArray64.t *
                                                               trace = {
    var ms:W64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var b_result:BArray64.t;
    var b_param:BArray64.t;
    var trace_jade_hash_sha512_amd64_avx2:trace;
    b_param <- witness;
    b_result <- witness;
    param_2 <- witness;
    result_0 <- witness;
    trace_jade_hash_sha512_amd64_avx2 <- [];
    trace_jade_hash_sha512_amd64_avx2 <-
    (trace_jade_hash_sha512_amd64_avx2 ++
    [(Assert,
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)))]);
    ms <- (init_msf);
    b_param <- b_out;
    param_2 <- out;
    param_1 <- in_0;
    param_0 <- inlen;
    param <- ms;
    (result_0, b_result, result, tmp__trace) <@ _sha512_mem (param_2,
    b_param, param_1, param_0, param);
    trace_jade_hash_sha512_amd64_avx2 <-
    (trace_jade_hash_sha512_amd64_avx2 ++ tmp__trace);
    trace_jade_hash_sha512_amd64_avx2 <-
    (trace_jade_hash_sha512_amd64_avx2 ++
    [(Assert, (BArray64.is_init b_result 0 64))]);
    out <- result_0;
    b_out <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, trace_jade_hash_sha512_amd64_avx2);
  }
  proc jade_hash_sha512_amd64_avx2_init (ctx:BArray208.t, b_ctx:BArray208.t) : 
  BArray208.t * BArray208.t * trace = {
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var ms:W64.t;
    var h:BArray64.t;
    var tag:W64.t;
    var total:W64.t;
    var param:BArray64.t;
    var result:BArray64.t;
    var param_0:int;
    var result_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:BArray64.t;
    var param_4:BArray208.t;
    var result_1:BArray208.t;
    var b_result:BArray208.t;
    var b_param:BArray208.t;
    var b_h:BArray64.t;
    var b_result_0:BArray64.t;
    var b_param_0:BArray64.t;
    var trace_jade_hash_sha512_amd64_avx2_init:trace;
    b_h <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    h <- witness;
    param <- witness;
    param_3 <- witness;
    param_4 <- witness;
    result <- witness;
    result_1 <- witness;
    trace_jade_hash_sha512_amd64_avx2_init <- [];
    b_h <- (BArray64.init_arr (W8.of_int 0));
    ms <- (init_msf);
    b_param_0 <- b_h;
    param <- h;
    (aux, aux_0, tmp__trace) <@ __sha512_init (param, b_param_0);
    result <- aux;
    b_result_0 <- aux_0;
    trace_jade_hash_sha512_amd64_avx2_init <-
    (trace_jade_hash_sha512_amd64_avx2_init ++ tmp__trace);
    trace_jade_hash_sha512_amd64_avx2_init <-
    (trace_jade_hash_sha512_amd64_avx2_init ++
    [(Assert, (BArray64.is_init b_result_0 0 64))]);
    h <- result;
    param_0 <- 4;
    (result_0, tmp__trace) <@ __sha2_tag (param_0);
    trace_jade_hash_sha512_amd64_avx2_init <-
    (trace_jade_hash_sha512_amd64_avx2_init ++ tmp__trace);
    tag <- result_0;
    total <- (W64.of_int 0);
    b_param <- b_ctx;
    param_4 <- ctx;
    param_3 <- h;
    param_2 <- tag;
    param_1 <- total;
    (result_1, b_result, tmp__trace) <@ __sha512_ctx_init (param_4, b_param,
    param_3, (BArray64.init_arr (W8.of_int 255)), param_2, param_1);
    trace_jade_hash_sha512_amd64_avx2_init <-
    (trace_jade_hash_sha512_amd64_avx2_init ++ tmp__trace);
    trace_jade_hash_sha512_amd64_avx2_init <-
    (trace_jade_hash_sha512_amd64_avx2_init ++
    [(Assert, (BArray208.is_init b_result 0 208))]);
    ctx <- result_1;
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, trace_jade_hash_sha512_amd64_avx2_init);
  }
  proc jade_hash_sha512_amd64_avx2_update (ctx:BArray208.t,
                                           b_ctx:BArray208.t, in_0:W64.t,
                                           inlen:W64.t) : BArray208.t *
                                                          BArray208.t *
                                                          W64.t * trace = {
    var status:W64.t;
    var ms:W64.t;
    var expect_0:W64.t;
    var param:int;
    var result:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:W64.t;
    var param_3:W64.t;
    var param_4:BArray208.t;
    var result_0:W64.t;
    var result_1:W64.t;
    var result_2:BArray208.t;
    var b_result:BArray208.t;
    var trace_jade_hash_sha512_amd64_avx2_update:trace;
    b_result <- witness;
    param_4 <- witness;
    result_2 <- witness;
    trace_jade_hash_sha512_amd64_avx2_update <- [];
    trace_jade_hash_sha512_amd64_avx2_update <-
    (trace_jade_hash_sha512_amd64_avx2_update ++
    [(Assert,
     ((BArray208.is_init b_ctx 0 208) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen))))]);
    ms <- (init_msf);
    param <- 4;
    (result, tmp__trace) <@ __sha2_tag (param);
    trace_jade_hash_sha512_amd64_avx2_update <-
    (trace_jade_hash_sha512_amd64_avx2_update ++ tmp__trace);
    expect_0 <- result;
    param_4 <- ctx;
    param_3 <- in_0;
    param_2 <- inlen;
    param_1 <- expect_0;
    param_0 <- ms;
    (result_2, b_result, result_1, result_0, tmp__trace) <@ _sha512_ctx_update (
    param_4, (BArray208.init_arr (W8.of_int 255)), param_3, param_2, 
    param_1, param_0);
    trace_jade_hash_sha512_amd64_avx2_update <-
    (trace_jade_hash_sha512_amd64_avx2_update ++ tmp__trace);
    trace_jade_hash_sha512_amd64_avx2_update <-
    (trace_jade_hash_sha512_amd64_avx2_update ++
    [(Assert, (BArray208.is_init b_result 0 208))]);
    ctx <- result_2;
    status <- result_1;
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, status, trace_jade_hash_sha512_amd64_avx2_update);
  }
  proc jade_hash_sha512_amd64_avx2_final (ctx:BArray208.t, b_ctx:BArray208.t,
                                          out:BArray64.t, b_out:BArray64.t) : 
  BArray208.t * BArray208.t * BArray64.t * BArray64.t * W64.t * trace = {
    var status:W64.t;
    var ms:W64.t;
    var expect_0:W64.t;
    var param:int;
    var result:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var param_3:BArray208.t;
    var result_0:W64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var result_3:BArray208.t;
    var b_result:BArray64.t;
    var b_result_0:BArray208.t;
    var b_param:BArray64.t;
    var trace_jade_hash_sha512_amd64_avx2_final:trace;
    b_param <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    param_2 <- witness;
    param_3 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    trace_jade_hash_sha512_amd64_avx2_final <- [];
    trace_jade_hash_sha512_amd64_avx2_final <-
    (trace_jade_hash_sha512_amd64_avx2_final ++
    [(Assert, (BArray208.is_init b_ctx 0 208))]);
    ms <- (init_msf);
    param <- 4;
    (result, tmp__trace) <@ __sha2_tag (param);
    trace_jade_hash_sha512_amd64_avx2_final <-
    (trace_jade_hash_sha512_amd64_avx2_final ++ tmp__trace);
    expect_0 <- result;
    param_3 <- ctx;
    b_param <- b_out;
    param_2 <- out;
    param_1 <- expect_0;
    param_0 <- ms;
    (result_3, b_result_0, result_2, b_result, result_1, result_0,
    tmp__trace) <@ _sha512_ctx___sha2_ctx_final (param_3,
    (BArray208.init_arr (W8.of_int 255)), param_2, b_param, param_1,
    param_0);
    trace_jade_hash_sha512_amd64_avx2_final <-
    (trace_jade_hash_sha512_amd64_avx2_final ++ tmp__trace);
    trace_jade_hash_sha512_amd64_avx2_final <-
    (trace_jade_hash_sha512_amd64_avx2_final ++
    [(Assert,
     ((BArray208.is_init b_result_0 0 208) /\
     (BArray64.is_init b_result 0 ((result_1 = (W64.of_int 0)) ? 64 : 0))))]);
    ctx <- result_3;
    b_out <- b_result;
    out <- result_2;
    status <- result_1;
    b_ctx <- (BArray208.init_arr (W8.of_int 255));
    return (ctx, b_ctx, out, b_out, status,
           trace_jade_hash_sha512_amd64_avx2_final);
  }
  proc _hmac_sha256_mem (out:BArray32.t, b_out:BArray32.t, key:W64.t,
                         keylen:W64.t, msg:W64.t, msglen:W64.t, ms:W64.t) : 
  BArray32.t * BArray32.t * W64.t * trace = {
    var aux:BArray32.t;
    var aux_0:BArray32.t;
    var aux_1:BArray32.t;
    var aux_2:BArray32.t;
    var aux_4:BArray64.t;
    var aux_5:BArray64.t;
    var aux_3:W64.t;
    var aux_6:W64.t;
    var k0:BArray64.t;
    var inner:BArray32.t;
    var outer:BArray32.t;
    var total:W64.t;
    var buf:BArray64.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray64.t;
    var result:W64.t;
    var result_0:BArray64.t;
    var param_3:W64.t;
    var param_4:BArray64.t;
    var param_5:BArray32.t;
    var param_6:BArray32.t;
    var result_1:W64.t;
    var result_2:BArray32.t;
    var result_3:BArray32.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:W64.t;
    var param_11:BArray64.t;
    var param_12:BArray32.t;
    var result_4:W64.t;
    var result_5:W64.t;
    var result_6:BArray64.t;
    var result_7:BArray32.t;
    var param_13:W64.t;
    var param_14:BArray32.t;
    var param_15:W64.t;
    var param_16:BArray64.t;
    var param_17:BArray32.t;
    var result_8:W64.t;
    var result_9:W64.t;
    var result_10:BArray64.t;
    var result_11:BArray32.t;
    var param_18:W64.t;
    var param_19:W64.t;
    var param_20:BArray64.t;
    var param_21:BArray32.t;
    var param_22:BArray32.t;
    var result_12:W64.t;
    var result_13:BArray64.t;
    var result_14:BArray32.t;
    var result_15:BArray32.t;
    var b_buf:BArray64.t;
    var b_result:BArray64.t;
    var b_inner:BArray32.t;
    var b_result_0:BArray32.t;
    var b_result_1:BArray32.t;
    var b_param:BArray64.t;
    var b_param_0:BArray32.t;
    var b_result_2:BArray64.t;
    var b_result_3:BArray32.t;
    var b_param_1:BArray64.t;
    var b_outer:BArray32.t;
    var b_result_4:BArray64.t;
    var b_result_5:BArray32.t;
    var b_param_2:BArray64.t;
    var b_result_6:BArray32.t;
    var b_result_7:BArray32.t;
    var b_param_3:BArray32.t;
    var b_param_4:BArray32.t;
    var b_k0:BArray64.t;
    var b_result_8:BArray64.t;
    var b_param_5:BArray64.t;
    var trace__hmac_sha256_mem:trace;
    b_buf <- witness;
    b_inner <- witness;
    b_k0 <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_param_3 <- witness;
    b_param_4 <- witness;
    b_param_5 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    b_result_4 <- witness;
    b_result_5 <- witness;
    b_result_6 <- witness;
    b_result_7 <- witness;
    b_result_8 <- witness;
    buf <- witness;
    inner <- witness;
    k0 <- witness;
    outer <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_11 <- witness;
    param_12 <- witness;
    param_14 <- witness;
    param_16 <- witness;
    param_17 <- witness;
    param_20 <- witness;
    param_21 <- witness;
    param_22 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_6 <- witness;
    result_7 <- witness;
    result_10 <- witness;
    result_11 <- witness;
    result_13 <- witness;
    result_14 <- witness;
    result_15 <- witness;
    trace__hmac_sha256_mem <- [];
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert,
     ((is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)
      ) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint msg) (W64.to_uint msglen))))]);
    b_k0 <- (BArray64.init_arr (W8.of_int 0));
    b_buf <- (BArray64.init_arr (W8.of_int 0));
    b_inner <- (BArray32.init_arr (W8.of_int 0));
    b_outer <- (BArray32.init_arr (W8.of_int 0));
    (* Erased call to spill *)
    b_param_5 <- b_k0;
    param_2 <- k0;
    param_1 <- key;
    param_0 <- keylen;
    param <- ms;
    (result_0, b_result_8, result, tmp__trace) <@ _hmac_sha256_keyblock_mem (
    param_2, b_param_5, param_1, param_0, param);
    trace__hmac_sha256_mem <- (trace__hmac_sha256_mem ++ tmp__trace);
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert, (BArray64.is_init b_result_8 0 64))]);
    k0 <- result_0;
    ms <- result;
    b_param_4 <- b_inner;
    param_6 <- inner;
    b_param_3 <- b_outer;
    param_5 <- outer;
    param_4 <- k0;
    param_3 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ __hmac_sha256_init (
    param_6, b_param_4, param_5, b_param_3, param_4,
    (BArray64.init_arr (W8.of_int 255)), param_3);
    result_3 <- aux;
    b_result_7 <- aux_0;
    result_2 <- aux_1;
    b_result_6 <- aux_2;
    result_1 <- aux_3;
    trace__hmac_sha256_mem <- (trace__hmac_sha256_mem ++ tmp__trace);
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert,
     ((BArray32.is_init b_result_7 0 32) /\
     (BArray32.is_init b_result_6 0 32)))]);
    inner <- result_3;
    outer <- result_2;
    ms <- result_1;
    (* Erased call to unspill *)
    msg <- (protect_64 msg ms);
    msglen <- (protect_64 msglen ms);
    total <- (W64.of_int 64);
    param_12 <- inner;
    b_param_2 <- b_buf;
    param_11 <- buf;
    param_10 <- total;
    param_9 <- msg;
    param_8 <- msglen;
    param_7 <- ms;
    (aux, aux_0, aux_4, aux_5, aux_3, aux_6, tmp__trace) <@ _sha256_absorb_mem (
    param_12, (BArray32.init_arr (W8.of_int 255)), param_11, b_param_2,
    param_10, param_9, param_8, param_7);
    result_7 <- aux;
    b_result_5 <- aux_0;
    result_6 <- aux_4;
    b_result_4 <- aux_5;
    result_5 <- aux_3;
    result_4 <- aux_6;
    trace__hmac_sha256_mem <- (trace__hmac_sha256_mem ++ tmp__trace);
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert,
     (((BArray32.is_init b_result_5 0 32) /\
      (BArray64.is_init b_result_4 0
      (W64.to_uint (result_5 \umod (W64.of_int 64))))) /\
     (result_5 = (param_10 + param_8))))]);
    inner <- result_7;
    b_buf <- b_result_4;
    buf <- result_6;
    total <- result_5;
    ms <- result_4;
    param_17 <- inner;
    b_param_1 <- b_buf;
    param_16 <- buf;
    param_15 <- total;
    param_14 <- outer;
    param_13 <- ms;
    (aux, aux_0, aux_4, aux_5, aux_3, aux_6, tmp__trace) <@ __hmac_sha256_outer (
    param_17, (BArray32.init_arr (W8.of_int 255)), param_16, b_param_1,
    param_15, param_14, (BArray32.init_arr (W8.of_int 255)), param_13);
    result_11 <- aux;
    b_result_3 <- aux_0;
    result_10 <- aux_4;
    b_result_2 <- aux_5;
    result_9 <- aux_3;
    result_8 <- aux_6;
    trace__hmac_sha256_mem <- (trace__hmac_sha256_mem ++ tmp__trace);
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert,
     (((BArray32.is_init b_result_3 0 32) /\
      (BArray64.is_init b_result_2 0 32)) /\
     (result_9 = (W64.of_int 96))))]);
    inner <- result_11;
    b_buf <- b_result_2;
    buf <- result_10;
    total <- result_9;
    ms <- result_8;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_22 <- out;
    param_21 <- inner;
    b_param <- b_buf;
    param_20 <- buf;
    param_19 <- total;
    param_18 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_4, aux_5, aux_3, tmp__trace) <@ _sha256___sha256_finalize (
    param_22, b_param_0, param_21, (BArray32.init_arr (W8.of_int 255)),
    param_20, b_param, param_19, param_18);
    result_15 <- aux;
    b_result_1 <- aux_0;
    result_14 <- aux_1;
    b_result_0 <- aux_2;
    result_13 <- aux_4;
    b_result <- aux_5;
    result_12 <- aux_3;
    trace__hmac_sha256_mem <- (trace__hmac_sha256_mem ++ tmp__trace);
    trace__hmac_sha256_mem <-
    (trace__hmac_sha256_mem ++
    [(Assert,
     (((BArray32.is_init b_result_1 0 32) /\
      (BArray32.is_init b_result_0 0 32)) /\
     (BArray64.is_init b_result 0 64)))]);
    out <- result_15;
    ms <- result_12;
    b_out <- (BArray32.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__hmac_sha256_mem);
  }
  proc _hmac_sha512_mem (out:BArray64.t, b_out:BArray64.t, key:W64.t,
                         keylen:W64.t, msg:W64.t, msglen:W64.t, ms:W64.t) : 
  BArray64.t * BArray64.t * W64.t * trace = {
    var aux_4:BArray128.t;
    var aux_5:BArray128.t;
    var aux:BArray64.t;
    var aux_0:BArray64.t;
    var aux_1:BArray64.t;
    var aux_2:BArray64.t;
    var aux_3:W64.t;
    var aux_6:W64.t;
    var k0:BArray128.t;
    var inner:BArray64.t;
    var outer:BArray64.t;
    var total:W64.t;
    var buf:BArray128.t;
    var param:W64.t;
    var param_0:W64.t;
    var param_1:W64.t;
    var param_2:BArray128.t;
    var result:W64.t;
    var result_0:BArray128.t;
    var param_3:W64.t;
    var param_4:BArray128.t;
    var param_5:BArray64.t;
    var param_6:BArray64.t;
    var result_1:W64.t;
    var result_2:BArray64.t;
    var result_3:BArray64.t;
    var param_7:W64.t;
    var param_8:W64.t;
    var param_9:W64.t;
    var param_10:W64.t;
    var param_11:BArray128.t;
    var param_12:BArray64.t;
    var result_4:W64.t;
    var result_5:W64.t;
    var result_6:BArray128.t;
    var result_7:BArray64.t;
    var param_13:W64.t;
    var param_14:BArray64.t;
    var param_15:W64.t;
    var param_16:BArray128.t;
    var param_17:BArray64.t;
    var result_8:W64.t;
    var result_9:W64.t;
    var result_10:BArray128.t;
    var result_11:BArray64.t;
    var param_18:W64.t;
    var param_19:W64.t;
    var param_20:BArray128.t;
    var param_21:BArray64.t;
    var param_22:BArray64.t;
    var result_12:W64.t;
    var result_13:BArray128.t;
    var result_14:BArray64.t;
    var result_15:BArray64.t;
    var b_buf:BArray128.t;
    var b_result:BArray128.t;
    var b_inner:BArray64.t;
    var b_result_0:BArray64.t;
    var b_result_1:BArray64.t;
    var b_param:BArray128.t;
    var b_param_0:BArray64.t;
    var b_result_2:BArray128.t;
    var b_result_3:BArray64.t;
    var b_param_1:BArray128.t;
    var b_outer:BArray64.t;
    var b_result_4:BArray128.t;
    var b_result_5:BArray64.t;
    var b_param_2:BArray128.t;
    var b_result_6:BArray64.t;
    var b_result_7:BArray64.t;
    var b_param_3:BArray64.t;
    var b_param_4:BArray64.t;
    var b_k0:BArray128.t;
    var b_result_8:BArray128.t;
    var b_param_5:BArray128.t;
    var trace__hmac_sha512_mem:trace;
    b_buf <- witness;
    b_inner <- witness;
    b_k0 <- witness;
    b_outer <- witness;
    b_param <- witness;
    b_param_0 <- witness;
    b_param_1 <- witness;
    b_param_2 <- witness;
    b_param_3 <- witness;
    b_param_4 <- witness;
    b_param_5 <- witness;
    b_result <- witness;
    b_result_0 <- witness;
    b_result_1 <- witness;
    b_result_2 <- witness;
    b_result_3 <- witness;
    b_result_4 <- witness;
    b_result_5 <- witness;
    b_result_6 <- witness;
    b_result_7 <- witness;
    b_result_8 <- witness;
    buf <- witness;
    inner <- witness;
    k0 <- witness;
    outer <- witness;
    param_2 <- witness;
    param_4 <- witness;
    param_5 <- witness;
    param_6 <- witness;
    param_11 <- witness;
    param_12 <- witness;
    param_14 <- witness;
    param_16 <- witness;
    param_17 <- witness;
    param_20 <- witness;
    param_21 <- witness;
    param_22 <- witness;
    result_0 <- witness;
    result_2 <- witness;
    result_3 <- witness;
    result_6 <- witness;
    result_7 <- witness;
    result_10 <- witness;
    result_11 <- witness;
    result_13 <- witness;
    result_14 <- witness;
    result_15 <- witness;
    trace__hmac_sha512_mem <- [];
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert,
     ((is_valid ptr_modulus Glob.mem_v (W64.to_uint key) (W64.to_uint keylen)
      ) /\
     (is_valid ptr_modulus Glob.mem_v (W64.to_uint msg) (W64.to_uint msglen))))]);
    b_k0 <- (BArray128.init_arr (W8.of_int 0));
    b_buf <- (BArray128.init_arr (W8.of_int 0));
    b_inner <- (BArray64.init_arr (W8.of_int 0));
    b_outer <- (BArray64.init_arr (W8.of_int 0));
    (* Erased call to spill *)
    b_param_5 <- b_k0;
    param_2 <- k0;
    param_1 <- key;
    param_0 <- keylen;
    param <- ms;
    (result_0, b_result_8, result, tmp__trace) <@ _hmac_sha512_keyblock_mem (
    param_2, b_param_5, param_1, param_0, param);
    trace__hmac_sha512_mem <- (trace__hmac_sha512_mem ++ tmp__trace);
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert, (BArray128.is_init b_result_8 0 128))]);
    k0 <- result_0;
    ms <- result;
    b_param_4 <- b_inner;
    param_6 <- inner;
    b_param_3 <- b_outer;
    param_5 <- outer;
    param_4 <- k0;
    param_3 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_3, tmp__trace) <@ __hmac_sha512_init (
    param_6, b_param_4, param_5, b_param_3, param_4,
    (BArray128.init_arr (W8.of_int 255)), param_3);
    result_3 <- aux;
    b_result_7 <- aux_0;
    result_2 <- aux_1;
    b_result_6 <- aux_2;
    result_1 <- aux_3;
    trace__hmac_sha512_mem <- (trace__hmac_sha512_mem ++ tmp__trace);
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert,
     ((BArray64.is_init b_result_7 0 64) /\
     (BArray64.is_init b_result_6 0 64)))]);
    inner <- result_3;
    outer <- result_2;
    ms <- result_1;
    (* Erased call to unspill *)
    msg <- (protect_64 msg ms);
    msglen <- (protect_64 msglen ms);
    total <- (W64.of_int 128);
    param_12 <- inner;
    b_param_2 <- b_buf;
    param_11 <- buf;
    param_10 <- total;
    param_9 <- msg;
    param_8 <- msglen;
    param_7 <- ms;
    (aux, aux_0, aux_4, aux_5, aux_3, aux_6, tmp__trace) <@ _sha512_absorb_mem (
    param_12, (BArray64.init_arr (W8.of_int 255)), param_11, b_param_2,
    param_10, param_9, param_8, param_7);
    result_7 <- aux;
    b_result_5 <- aux_0;
    result_6 <- aux_4;
    b_result_4 <- aux_5;
    result_5 <- aux_3;
    result_4 <- aux_6;
    trace__hmac_sha512_mem <- (trace__hmac_sha512_mem ++ tmp__trace);
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert,
     (((BArray64.is_init b_result_5 0 64) /\
      (BArray128.is_init b_result_4 0
      (W64.to_uint (result_5 \umod (W64.of_int 128))))) /\
     (result_5 = (param_10 + param_8))))]);
    inner <- result_7;
    b_buf <- b_result_4;
    buf <- result_6;
    total <- result_5;
    ms <- result_4;
    param_17 <- inner;
    b_param_1 <- b_buf;
    param_16 <- buf;
    param_15 <- total;
    param_14 <- outer;
    param_13 <- ms;
    (aux, aux_0, aux_4, aux_5, aux_3, aux_6, tmp__trace) <@ __hmac_sha512_outer (
    param_17, (BArray64.init_arr (W8.of_int 255)), param_16, b_param_1,
    param_15, param_14, (BArray64.init_arr (W8.of_int 255)), param_13);
    result_11 <- aux;
    b_result_3 <- aux_0;
    result_10 <- aux_4;
    b_result_2 <- aux_5;
    result_9 <- aux_3;
    result_8 <- aux_6;
    trace__hmac_sha512_mem <- (trace__hmac_sha512_mem ++ tmp__trace);
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert,
     (((BArray64.is_init b_result_3 0 64) /\
      (BArray128.is_init b_result_2 0 64)) /\
     (result_9 = (W64.of_int 192))))]);
    inner <- result_11;
    b_buf <- b_result_2;
    buf <- result_10;
    total <- result_9;
    ms <- result_8;
    (* Erased call to unspill *)
    b_param_0 <- b_out;
    param_22 <- out;
    param_21 <- inner;
    b_param <- b_buf;
    param_20 <- buf;
    param_19 <- total;
    param_18 <- ms;
    (aux, aux_0, aux_1, aux_2, aux_4, aux_5, aux_3, tmp__trace) <@ _sha512___sha512_finalize (
    param_22, b_param_0, param_21, (BArray64.init_arr (W8.of_int 255)),
    param_20, b_param, param_19, param_18);
    result_15 <- aux;
    b_result_1 <- aux_0;
    result_14 <- aux_1;
    b_result_0 <- aux_2;
    result_13 <- aux_4;
    b_result <- aux_5;
    result_12 <- aux_3;
    trace__hmac_sha512_mem <- (trace__hmac_sha512_mem ++ tmp__trace);
    trace__hmac_sha512_mem <-
    (trace__hmac_sha512_mem ++
    [(Assert,
     (((BArray64.is_init b_result_1 0 64) /\
      (BArray64.is_init b_result_0 0 64)) /\
     (BArray128.is_init b_result 0 128)))]);
    out <- result_15;
    ms <- result_12;
    b_out <- (BArray64.init_arr (W8.of_int 255));
    return (out, b_out, ms, trace__hmac_sha512_mem);
  }
}.

(* The post and trace are valid. *)

op __bswap32_spec _x =
   hoare [M.__bswap32 : ((_x = x) /\ true) ==> (true /\ (valid res.`2))].

op __bswap64_spec _x =
   hoare [M.__bswap64 : ((_x = x) /\ true) ==> (true /\ (valid res.`2))].

op __fill64_mem_spec _buf _b_buf _dst_ _p_ _n_ _ms =
   hoare [M.__fill64_mem :
   (((_ms = ms) /\
    ((_n_ = n_) /\
    ((_p_ = p_) /\ ((_dst_ = dst_) /\ ((_b_buf = b_buf) /\ (_buf = buf)))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (((((_dst_ \ule (W64.of_int 64)) /\ (_n_ \ule (W64.of_int 64))) /\
     ((_dst_ + _n_) \ule (W64.of_int 64))) /\
    (BArray64.is_init _b_buf 0 (W64.to_uint _dst_))) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p_) (W64.to_uint _n_))))))))))) ==>
   ((true /\
    (true /\ (BArray64.is_init res.`2 0 (W64.to_uint (_dst_ + _n_))))) /\
   (valid res.`4))].

op __fill128_mem_spec _buf _b_buf _dst_ _p_ _n_ _ms =
   hoare [M.__fill128_mem :
   (((_ms = ms) /\
    ((_n_ = n_) /\
    ((_p_ = p_) /\ ((_dst_ = dst_) /\ ((_b_buf = b_buf) /\ (_buf = buf)))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (true /\
   (((((_dst_ \ule (W64.of_int 128)) /\ (_n_ \ule (W64.of_int 128))) /\
     ((_dst_ + _n_) \ule (W64.of_int 128))) /\
    (BArray128.is_init _b_buf 0 (W64.to_uint _dst_))) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p_) (W64.to_uint _n_))))))))))) ==>
   ((true /\
    (true /\ (BArray128.is_init res.`2 0 (W64.to_uint (_dst_ + _n_))))) /\
   (valid res.`4))].

op __zero64_spec _buf _b_buf _lo_ _hi _ms =
   hoare [M.__zero64 :
   (((_ms = ms) /\
    ((_hi = hi) /\ ((_lo_ = lo_) /\ ((_b_buf = b_buf) /\ (_buf = buf))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   (((_lo_ \ule _hi) /\ (_hi \ule (W64.of_int 64))) /\
   (BArray64.is_init _b_buf 0 (W64.to_uint _lo_)))))))) ==>
   ((true /\ (BArray64.is_init res.`2 0 (W64.to_uint _hi))) /\
   (valid res.`4))].

op __zero128_spec _buf _b_buf _lo_ _hi _ms =
   hoare [M.__zero128 :
   (((_ms = ms) /\
    ((_hi = hi) /\ ((_lo_ = lo_) /\ ((_b_buf = b_buf) /\ (_buf = buf))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   (((_lo_ \ule _hi) /\ (_hi \ule (W64.of_int 128))) /\
   (BArray128.is_init _b_buf 0 (W64.to_uint _lo_)))))))) ==>
   ((true /\ (BArray128.is_init res.`2 0 (W64.to_uint _hi))) /\
   (valid res.`4))].

op __sha256_avx2_round_spec _v _b_v _m _b_m _s _t _x _b_x _lo _hi _j _ph =
   hoare [M.__sha256_avx2_round :
   (((_ph = ph) /\
    ((_j = j) /\
    ((_hi = hi) /\
    ((_lo = lo) /\
    ((_b_x = b_x) /\
    ((_x = x) /\
    ((_t = t) /\
    ((_s = s) /\ ((_b_m = b_m) /\ ((_m = m) /\ ((_b_v = b_v) /\ (_v = v)))))))))))) /\
   (true /\
   (true /\
   (true /\
   (((((0 <= _t) /\ (_t < 64)) /\ (BArray32.is_init _b_v 0 32)) /\
    (BArray8.is_init _b_m (4 * (_t %% 2)) 4)) /\
   (BArray128.is_init _b_x 0 128)))))) ==>
   ((((BArray32.is_init res.`2 0 32) /\ (BArray8.is_init res.`4 0 8)) /\
    (BArray128.is_init res.`7 0 128)) /\
   (valid res.`8))].

op __sha256_avx2_spec _h _b_h _x _b_x _nb _ms =
   hoare [M.__sha256_avx2 :
   (((_ms = ms) /\
    ((_nb = nb) /\
    ((_b_x = b_x) /\ ((_x = x) /\ ((_b_h = b_h) /\ (_h = h)))))) /\
   (true /\
   (true /\
   ((((0 <= _nb) /\ (_nb <= 2)) /\ (BArray32.is_init _b_h 0 32)) /\
   (BArray128.is_init _b_x 0 128))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha256_compress_spec _h _b_h _block _b_block _ms =
   hoare [M._sha256_compress :
   (((_ms = ms) /\
    ((_b_block = b_block) /\
    ((_block = block) /\ ((_b_h = b_h) /\ (_h = h))))) /\
   ((BArray32.is_init _b_h 0 32) /\ (BArray64.is_init _b_block 0 64))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha256_compress_one_spec _h _b_h _p _ms =
   hoare [M._sha256_compress_one :
   (((_ms = ms) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h)))) /\
   (true /\
   ((BArray32.is_init _b_h 0 32) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p) 64)))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha256_compress_two_spec _h _b_h _p _ms =
   hoare [M._sha256_compress_two :
   (((_ms = ms) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h)))) /\
   (true /\
   ((BArray32.is_init _b_h 0 32) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p) 128)))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha256_compress_blocks_spec _h _b_h _p _n _ms =
   hoare [M._sha256_compress_blocks :
   (((_ms = ms) /\ ((_n = n) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h))))) /\
   (true /\
   (true /\
   (true /\
   (((BArray32.is_init _b_h 0 32) /\
    (_n \ult (W64.of_int 288230376151711744))) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p)
   (W64.to_uint ((W64.of_int 64) * _n)))))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op __sha256_init_spec _h _b_h =
   hoare [M.__sha256_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`3))].

op __sha224_init_spec _h _b_h =
   hoare [M.__sha224_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`3))].

op _sha256_absorb_mem_spec _h _b_h _buf _b_buf _total _in _inlen _ms =
   hoare [M._sha256_absorb_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\ ((_buf = buf) /\ ((_b_h = b_h) /\ (_h = h)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 64)) <> 0) /\
   (true /\
   (true /\
   (((BArray32.is_init _b_h 0 32) /\
    (BArray64.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 64))))) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))))) ==>
   ((true /\
    (((W64.to_uint (W64.of_int 64)) <> 0) /\
    (true /\
    (true /\
    (true /\
    (((BArray32.is_init res.`2 0 32) /\
     (BArray64.is_init res.`4 0 (W64.to_uint (res.`5 \umod (W64.of_int 64))))) /\
    (res.`5 = (_total + _inlen)))))))) /\
   (valid res.`7))].

op _sha256___sha256_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha256___sha256_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 64)) <> 0) /\
   ((BArray32.is_init _b_h 0 32) /\
   (BArray64.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 64)))))))) ==>
   ((((BArray32.is_init res.`2 0 32) /\ (BArray32.is_init res.`4 0 32)) /\
    (BArray64.is_init res.`6 0 64)) /\
   (valid res.`8))].

op _sha256____sha256_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha256____sha256_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray32.is_init _b_h 0 32) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha224___sha256_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha224___sha256_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 64)) <> 0) /\
   ((BArray32.is_init _b_h 0 32) /\
   (BArray64.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 64)))))))) ==>
   ((((BArray28.is_init res.`2 0 28) /\ (BArray32.is_init res.`4 0 32)) /\
    (BArray64.is_init res.`6 0 64)) /\
   (valid res.`8))].

op _sha224____sha256_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha224____sha256_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray32.is_init _b_h 0 32) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray28.is_init res.`2 0 28) /\ (valid res.`4))].

op _sha256_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha256_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha224_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha224_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray28.is_init res.`2 0 28) /\ (valid res.`4))].

op __sha512_avx2_round_spec _v _b_v _m _b_m _s _t _x _b_x _j _ph =
   hoare [M.__sha512_avx2_round :
   (((_ph = ph) /\
    ((_j = j) /\
    ((_b_x = b_x) /\
    ((_x = x) /\
    ((_t = t) /\
    ((_s = s) /\ ((_b_m = b_m) /\ ((_m = m) /\ ((_b_v = b_v) /\ (_v = v)))))))))) /\
   (true /\
   (true /\
   (true /\
   (((((0 <= _t) /\ (_t < 80)) /\ (BArray64.is_init _b_v 0 64)) /\
    (BArray16.is_init _b_m (8 * (_t %% 2)) 8)) /\
   (BArray256.is_init _b_x 0 256)))))) ==>
   ((((BArray64.is_init res.`2 0 64) /\ (BArray16.is_init res.`4 0 16)) /\
    (BArray256.is_init res.`7 0 256)) /\
   (valid res.`8))].

op __sha512_avx2_spec _h _b_h _x _b_x _nb _ms =
   hoare [M.__sha512_avx2 :
   (((_ms = ms) /\
    ((_nb = nb) /\
    ((_b_x = b_x) /\ ((_x = x) /\ ((_b_h = b_h) /\ (_h = h)))))) /\
   (true /\
   (true /\
   ((((0 <= _nb) /\ (_nb <= 2)) /\ (BArray64.is_init _b_h 0 64)) /\
   (BArray256.is_init _b_x 0 256))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha512_compress_spec _h _b_h _block _b_block _ms =
   hoare [M._sha512_compress :
   (((_ms = ms) /\
    ((_b_block = b_block) /\
    ((_block = block) /\ ((_b_h = b_h) /\ (_h = h))))) /\
   ((BArray64.is_init _b_h 0 64) /\ (BArray128.is_init _b_block 0 128))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha512_compress_one_spec _h _b_h _p _ms =
   hoare [M._sha512_compress_one :
   (((_ms = ms) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h)))) /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p) 128)))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha512_compress_two_spec _h _b_h _p _ms =
   hoare [M._sha512_compress_two :
   (((_ms = ms) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h)))) /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p) 256)))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha512_compress_blocks_spec _h _b_h _p _n _ms =
   hoare [M._sha512_compress_blocks :
   (((_ms = ms) /\ ((_n = n) /\ ((_p = p) /\ ((_b_h = b_h) /\ (_h = h))))) /\
   (true /\
   (true /\
   (true /\
   (((BArray64.is_init _b_h 0 64) /\
    (_n \ult (W64.of_int 144115188075855872))) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _p)
   (W64.to_uint ((W64.of_int 128) * _n)))))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op __sha512_load_iv_spec _h _b_h _iv _b_iv =
   hoare [M.__sha512_load_iv :
   (((_b_iv = b_iv) /\ ((_iv = iv) /\ ((_b_h = b_h) /\ (_h = h)))) /\
   (BArray64.is_init _b_iv 0 64)) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op __sha512_init_spec _h _b_h =
   hoare [M.__sha512_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op __sha384_init_spec _h _b_h =
   hoare [M.__sha384_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op __sha512_224_init_spec _h _b_h =
   hoare [M.__sha512_224_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op __sha512_256_init_spec _h _b_h =
   hoare [M.__sha512_256_init :
   (((_b_h = b_h) /\ (_h = h)) /\ true) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op _sha512_absorb_mem_spec _h _b_h _buf _b_buf _total _in _inlen _ms =
   hoare [M._sha512_absorb_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\ ((_buf = buf) /\ ((_b_h = b_h) /\ (_h = h)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   (true /\
   (true /\
   (((BArray64.is_init _b_h 0 64) /\
    (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))
    )) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))))) ==>
   ((true /\
    (((W64.to_uint (W64.of_int 128)) <> 0) /\
    (true /\
    (true /\
    (true /\
    (((BArray64.is_init res.`2 0 64) /\
     (BArray128.is_init res.`4 0
     (W64.to_uint (res.`5 \umod (W64.of_int 128))))) /\
    (res.`5 = (_total + _inlen)))))))) /\
   (valid res.`7))].

op _sha512___sha512_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha512___sha512_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   ((BArray64.is_init _b_h 0 64) /\
   (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))))))) ==>
   ((((BArray64.is_init res.`2 0 64) /\ (BArray64.is_init res.`4 0 64)) /\
    (BArray128.is_init res.`6 0 128)) /\
   (valid res.`8))].

op _sha512____sha512_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha512____sha512_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha384___sha512_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha384___sha512_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   ((BArray64.is_init _b_h 0 64) /\
   (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))))))) ==>
   ((((BArray48.is_init res.`2 0 48) /\ (BArray64.is_init res.`4 0 64)) /\
    (BArray128.is_init res.`6 0 128)) /\
   (valid res.`8))].

op _sha384____sha512_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha384____sha512_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray48.is_init res.`2 0 48) /\ (valid res.`4))].

op _sha512_224___sha512_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha512_224___sha512_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   ((BArray64.is_init _b_h 0 64) /\
   (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))))))) ==>
   ((((BArray28.is_init res.`2 0 28) /\ (BArray64.is_init res.`4 0 64)) /\
    (BArray128.is_init res.`6 0 128)) /\
   (valid res.`8))].

op _sha512_224____sha512_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha512_224____sha512_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray28.is_init res.`2 0 28) /\ (valid res.`4))].

op _sha512_256___sha512_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms =
   hoare [M._sha512_256___sha512_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   ((BArray64.is_init _b_h 0 64) /\
   (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))))))) ==>
   ((((BArray32.is_init res.`2 0 32) /\ (BArray64.is_init res.`4 0 64)) /\
    (BArray128.is_init res.`6 0 128)) /\
   (valid res.`8))].

op _sha512_256____sha512_mem_from_spec _out _b_out _h _b_h _in _inlen _ms =
   hoare [M._sha512_256____sha512_mem_from :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   ((BArray64.is_init _b_h 0 64) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _sha512_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha512_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _sha384_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha384_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray48.is_init res.`2 0 48) /\ (valid res.`4))].

op _sha512_224_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha512_224_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray28.is_init res.`2 0 28) /\ (valid res.`4))].

op _sha512_256_mem_spec _out _b_out _in _inlen _ms =
   hoare [M._sha512_256_mem :
   (((_ms = ms) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _hmac_sha256_keyblock_mem_spec _k0 _b_k0 _key _keylen _ms =
   hoare [M._hmac_sha256_keyblock_mem :
   (((_ms = ms) /\
    ((_keylen = keylen) /\ ((_key = key) /\ ((_b_k0 = b_k0) /\ (_k0 = k0))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].

op _hmac_sha512_keyblock_mem_spec _k0 _b_k0 _key _keylen _ms =
   hoare [M._hmac_sha512_keyblock_mem :
   (((_ms = ms) /\
    ((_keylen = keylen) /\ ((_key = key) /\ ((_b_k0 = b_k0) /\ (_k0 = k0))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen))))) ==>
   ((BArray128.is_init res.`2 0 128) /\ (valid res.`4))].

op __hmac_sha256_init_spec _inner _b_inner _outer _b_outer _k0 _b_k0 _ms =
   hoare [M.__hmac_sha256_init :
   (((_ms = ms) /\
    ((_b_k0 = b_k0) /\
    ((_k0 = k0) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\ ((_b_inner = b_inner) /\ (_inner = inner))))))) /\
   (BArray64.is_init _b_k0 0 64)) ==>
   (((BArray32.is_init res.`2 0 32) /\ (BArray32.is_init res.`4 0 32)) /\
   (valid res.`6))].

op __hmac_sha512_init_spec _inner _b_inner _outer _b_outer _k0 _b_k0 _ms =
   hoare [M.__hmac_sha512_init :
   (((_ms = ms) /\
    ((_b_k0 = b_k0) /\
    ((_k0 = k0) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\ ((_b_inner = b_inner) /\ (_inner = inner))))))) /\
   (BArray128.is_init _b_k0 0 128)) ==>
   (((BArray64.is_init res.`2 0 64) /\ (BArray64.is_init res.`4 0 64)) /\
   (valid res.`6))].

op __hmac_sha256_outer_spec _inner _b_inner _buf _b_buf _total _outer _b_outer _ms =
   hoare [M.__hmac_sha256_outer :
   (((_ms = ms) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\ ((_b_inner = b_inner) /\ (_inner = inner)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 64)) <> 0) /\
   (((BArray32.is_init _b_inner 0 32) /\
    (BArray64.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 64))))) /\
   (BArray32.is_init _b_outer 0 32))))) ==>
   ((true /\
    (((BArray32.is_init res.`2 0 32) /\ (BArray64.is_init res.`4 0 32)) /\
    (res.`5 = (W64.of_int 96)))) /\
   (valid res.`7))].

op __hmac_sha256_finalize_spec _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms =
   hoare [M.__hmac_sha256_finalize :
   (((_ms = ms) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_inner = b_inner) /\
    ((_inner = inner) /\ ((_b_out = b_out) /\ (_out = out)))))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 64)) <> 0) /\
   (((BArray32.is_init _b_inner 0 32) /\
    (BArray64.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 64))))) /\
   (BArray32.is_init _b_outer 0 32))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`8))].

op __hmac_sha512_outer_spec _inner _b_inner _buf _b_buf _total _outer _b_outer _ms =
   hoare [M.__hmac_sha512_outer :
   (((_ms = ms) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\ ((_b_inner = b_inner) /\ (_inner = inner)))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   (((BArray64.is_init _b_inner 0 64) /\
    (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))
    )) /\
   (BArray64.is_init _b_outer 0 64))))) ==>
   ((true /\
    (((BArray64.is_init res.`2 0 64) /\ (BArray128.is_init res.`4 0 64)) /\
    (res.`5 = (W64.of_int 192)))) /\
   (valid res.`7))].

op __hmac_sha512_finalize_spec _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms =
   hoare [M.__hmac_sha512_finalize :
   (((_ms = ms) /\
    ((_b_outer = b_outer) /\
    ((_outer = outer) /\
    ((_total = total) /\
    ((_b_buf = b_buf) /\
    ((_buf = buf) /\
    ((_b_inner = b_inner) /\
    ((_inner = inner) /\ ((_b_out = b_out) /\ (_out = out)))))))))) /\
   (true /\
   (((W64.to_uint (W64.of_int 128)) <> 0) /\
   (((BArray64.is_init _b_inner 0 64) /\
    (BArray128.is_init _b_buf 0 (W64.to_uint (_total \umod (W64.of_int 128)))
    )) /\
   (BArray64.is_init _b_outer 0 64))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`8))].

op __sha2_tag_spec _f =
   hoare [M.__sha2_tag : ((_f = f) /\ true) ==> (true /\ (valid res.`2))].

op __sha2_ctx_open_spec _head _b_head _ms =
   hoare [M.__sha2_ctx_open :
   (((_ms = ms) /\ ((_b_head = b_head) /\ (_head = head))) /\
   (BArray16.is_init _b_head 0 16)) ==> (true /\ (valid res.`3))].

op __sha2_room_spec _total =
   hoare [M.__sha2_room :
   ((_total = total) /\ true) ==> (true /\ (valid res.`2))].

op __sha256_ctx_load_spec _h _b_h _buf _b_buf _ctx _b_ctx =
   hoare [M.__sha256_ctx_load :
   (((_b_ctx = b_ctx) /\
    ((_ctx = ctx) /\
    ((_b_buf = b_buf) /\ ((_buf = buf) /\ ((_b_h = b_h) /\ (_h = h)))))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   (((BArray32.is_init res.`2 0 32) /\ (BArray64.is_init res.`4 0 64)) /\
   (valid res.`5))].

op __sha512_ctx_load_spec _h _b_h _buf _b_buf _ctx _b_ctx =
   hoare [M.__sha512_ctx_load :
   (((_b_ctx = b_ctx) /\
    ((_ctx = ctx) /\
    ((_b_buf = b_buf) /\ ((_buf = buf) /\ ((_b_h = b_h) /\ (_h = h)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   (((BArray64.is_init res.`2 0 64) /\ (BArray128.is_init res.`4 0 128)) /\
   (valid res.`5))].

op __sha256_ctx_init_spec _ctx _b_ctx _h _b_h _tag _total =
   hoare [M.__sha256_ctx_init :
   (((_total = total) /\
    ((_tag = tag) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray32.is_init _b_h 0 32)) ==>
   ((BArray112.is_init res.`2 0 112) /\ (valid res.`3))].

op __sha512_ctx_init_spec _ctx _b_ctx _h _b_h _tag _total =
   hoare [M.__sha512_ctx_init :
   (((_total = total) /\
    ((_tag = tag) /\
    ((_b_h = b_h) /\ ((_h = h) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray64.is_init _b_h 0 64)) ==>
   ((BArray208.is_init res.`2 0 208) /\ (valid res.`3))].

op _sha256_ctx_update_spec _ctx _b_ctx _in _inlen _expect _ms =
   hoare [M._sha256_ctx_update :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (true /\
   (true /\
   ((BArray112.is_init _b_ctx 0 112) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray112.is_init res.`2 0 112) /\ (valid res.`5))].

op _sha512_ctx_update_spec _ctx _b_ctx _in _inlen _expect _ms =
   hoare [M._sha512_ctx_update :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (true /\
   (true /\
   ((BArray208.is_init _b_ctx 0 208) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray208.is_init res.`2 0 208) /\ (valid res.`5))].

op _sha224_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha224_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   (((BArray112.is_init res.`2 0 112) /\ (BArray28.is_init res.`4 0 28)) /\
   (valid res.`6))].

op _sha224_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha224_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   ((true /\
    ((BArray112.is_init res.`2 0 112) /\
    (BArray28.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 28 : 0)))) /\
   (valid res.`7))].

op _sha256_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha256_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   (((BArray112.is_init res.`2 0 112) /\ (BArray32.is_init res.`4 0 32)) /\
   (valid res.`6))].

op _sha256_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha256_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   ((true /\
    ((BArray112.is_init res.`2 0 112) /\
    (BArray32.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 32 : 0)))) /\
   (valid res.`7))].

op _sha384_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha384_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   (((BArray208.is_init res.`2 0 208) /\ (BArray48.is_init res.`4 0 48)) /\
   (valid res.`6))].

op _sha384_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha384_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   ((true /\
    ((BArray208.is_init res.`2 0 208) /\
    (BArray48.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 48 : 0)))) /\
   (valid res.`7))].

op _sha512_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha512_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   (((BArray208.is_init res.`2 0 208) /\ (BArray64.is_init res.`4 0 64)) /\
   (valid res.`6))].

op _sha512_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha512_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   ((true /\
    ((BArray208.is_init res.`2 0 208) /\
    (BArray64.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 64 : 0)))) /\
   (valid res.`7))].

op _sha512_224_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha512_224_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   (((BArray208.is_init res.`2 0 208) /\ (BArray28.is_init res.`4 0 28)) /\
   (valid res.`6))].

op _sha512_224_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha512_224_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   ((true /\
    ((BArray208.is_init res.`2 0 208) /\
    (BArray28.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 28 : 0)))) /\
   (valid res.`7))].

op _sha512_256_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms =
   hoare [M._sha512_256_ctx____ctx_finalize :
   (((_ms = ms) /\
    ((_total = total) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   (((BArray208.is_init res.`2 0 208) /\ (BArray32.is_init res.`4 0 32)) /\
   (valid res.`6))].

op _sha512_256_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms =
   hoare [M._sha512_256_ctx___sha2_ctx_final :
   (((_ms = ms) /\
    ((_expect = expect_0) /\
    ((_b_digest = b_digest) /\
    ((_digest = digest) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   ((true /\
    ((BArray208.is_init res.`2 0 208) /\
    (BArray32.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 32 : 0)))) /\
   (valid res.`7))].

op __hmac_sha256_ctx_init_spec _ctx _b_ctx _key _keylen _ms =
   hoare [M.__hmac_sha256_ctx_init :
   (((_ms = ms) /\
    ((_keylen = keylen) /\
    ((_key = key) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen))))) ==>
   ((BArray144.is_init res.`2 0 144) /\ (valid res.`4))].

op __hmac_sha512_ctx_init_spec _ctx _b_ctx _key _keylen _ms =
   hoare [M.__hmac_sha512_ctx_init :
   (((_ms = ms) /\
    ((_keylen = keylen) /\
    ((_key = key) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx))))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen))))) ==>
   ((BArray272.is_init res.`2 0 272) /\ (valid res.`4))].

op __hmac_sha256_ctx_final_spec _ctx _b_ctx _out _b_out _ms =
   hoare [M.__hmac_sha256_ctx_final :
   (((_ms = ms) /\
    ((_b_out = b_out) /\
    ((_out = out) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx))))) /\
   (BArray144.is_init _b_ctx 0 144)) ==>
   ((true /\
    ((BArray144.is_init res.`2 0 144) /\
    (BArray32.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 32 : 0)))) /\
   (valid res.`7))].

op __hmac_sha512_ctx_final_spec _ctx _b_ctx _out _b_out _ms =
   hoare [M.__hmac_sha512_ctx_final :
   (((_ms = ms) /\
    ((_b_out = b_out) /\
    ((_out = out) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx))))) /\
   (BArray272.is_init _b_ctx 0 272)) ==>
   ((true /\
    ((BArray272.is_init res.`2 0 272) /\
    (BArray64.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 64 : 0)))) /\
   (valid res.`7))].

op jade_hash_sha256_amd64_avx2_spec _out _b_out _in _inlen =
   hoare [M.jade_hash_sha256_amd64_avx2 :
   (((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out)))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`3))].

op jade_hash_sha256_amd64_avx2_init_spec _ctx _b_ctx =
   hoare [M.jade_hash_sha256_amd64_avx2_init :
   (((_b_ctx = b_ctx) /\ (_ctx = ctx)) /\ true) ==>
   ((BArray112.is_init res.`2 0 112) /\ (valid res.`3))].

op jade_hash_sha256_amd64_avx2_update_spec _ctx _b_ctx _in _inlen =
   hoare [M.jade_hash_sha256_amd64_avx2_update :
   (((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))) /\
   (true /\
   (true /\
   ((BArray112.is_init _b_ctx 0 112) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray112.is_init res.`2 0 112) /\ (valid res.`4))].

op jade_hash_sha256_amd64_avx2_final_spec _ctx _b_ctx _out _b_out =
   hoare [M.jade_hash_sha256_amd64_avx2_final :
   (((_b_out = b_out) /\
    ((_out = out) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))) /\
   (BArray112.is_init _b_ctx 0 112)) ==>
   ((true /\
    ((BArray112.is_init res.`2 0 112) /\
    (BArray32.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 32 : 0)))) /\
   (valid res.`6))].

op jade_hash_sha512_amd64_avx2_spec _out _b_out _in _inlen =
   hoare [M.jade_hash_sha512_amd64_avx2 :
   (((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_out = b_out) /\ (_out = out)))) /\
   (true /\
   (true /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`3))].

op jade_hash_sha512_amd64_avx2_init_spec _ctx _b_ctx =
   hoare [M.jade_hash_sha512_amd64_avx2_init :
   (((_b_ctx = b_ctx) /\ (_ctx = ctx)) /\ true) ==>
   ((BArray208.is_init res.`2 0 208) /\ (valid res.`3))].

op jade_hash_sha512_amd64_avx2_update_spec _ctx _b_ctx _in _inlen =
   hoare [M.jade_hash_sha512_amd64_avx2_update :
   (((_inlen = inlen) /\
    ((_in = in_0) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))) /\
   (true /\
   (true /\
   ((BArray208.is_init _b_ctx 0 208) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)))))) ==>
   ((BArray208.is_init res.`2 0 208) /\ (valid res.`4))].

op jade_hash_sha512_amd64_avx2_final_spec _ctx _b_ctx _out _b_out =
   hoare [M.jade_hash_sha512_amd64_avx2_final :
   (((_b_out = b_out) /\
    ((_out = out) /\ ((_b_ctx = b_ctx) /\ (_ctx = ctx)))) /\
   (BArray208.is_init _b_ctx 0 208)) ==>
   ((true /\
    ((BArray208.is_init res.`2 0 208) /\
    (BArray64.is_init res.`4 0 ((res.`5 = (W64.of_int 0)) ? 64 : 0)))) /\
   (valid res.`6))].

op _hmac_sha256_mem_spec _out _b_out _key _keylen _msg _msglen _ms =
   hoare [M._hmac_sha256_mem :
   (((_ms = ms) /\
    ((_msglen = msglen) /\
    ((_msg = msg) /\
    ((_keylen = keylen) /\
    ((_key = key) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   ((is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen)
    ) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _msg) (W64.to_uint _msglen)))))))) ==>
   ((BArray32.is_init res.`2 0 32) /\ (valid res.`4))].

op _hmac_sha512_mem_spec _out _b_out _key _keylen _msg _msglen _ms =
   hoare [M._hmac_sha512_mem :
   (((_ms = ms) /\
    ((_msglen = msglen) /\
    ((_msg = msg) /\
    ((_keylen = keylen) /\
    ((_key = key) /\ ((_b_out = b_out) /\ (_out = out))))))) /\
   (true /\
   (true /\
   (true /\
   (true /\
   ((is_valid ptr_modulus Glob.mem_v (W64.to_uint _key) (W64.to_uint _keylen)
    ) /\
   (is_valid ptr_modulus Glob.mem_v (W64.to_uint _msg) (W64.to_uint _msglen)))))))) ==>
   ((BArray64.is_init res.`2 0 64) /\ (valid res.`4))].
