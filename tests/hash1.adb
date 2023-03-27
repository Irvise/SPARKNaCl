with SPARKNaCl;                use SPARKNaCl;
with SPARKNaCl.Debug;          use SPARKNaCl.Debug;
with SPARKNaCl.Hashing.SHA256; use SPARKNaCl.Hashing.SHA256;
with Interfaces;               use Interfaces;
procedure Hash1
is
   R1 : Digest;

   --  FIPS 180-2 SHA-256 test cases

   --  Case 1: One-block message
   M1 : constant String := "abc";

   --  Case 2: Multi-block message (448-bits)
   M2 : constant String :=
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq";

   --  Case 3: Long message
   M3 : constant String (1 .. 1_000_000) := (others => 'a');

   --  FIPS 180-4 SHA-256 Test Cases
   --  From https://csrc.nist.gov/Projects/ \
   --         Cryptographic-Algorithm-Validation-Program/Secure-Hashing
   --  SHA Test Vectors for Hashing Byte-Oriented Messages
   --  (SHA256ShortMsg.rsp)
   FIPS_0   : constant Byte_Seq (1 .. 0) := (others => <>);
   FIPS_8   : constant Byte_Seq (0 .. 0) := (others => 16#D3#);
   FIPS_16  : constant Byte_Seq := (16#11#, 16#AF#);
   FIPS_24  : constant Byte_Seq := (16#B4#, 16#19#, 16#0E#);
   FIPS_32  : constant Byte_Seq := (16#74#, 16#ba#, 16#25#, 16#21#);
   FIPS_40  : constant Byte_Seq := (
      16#c2#, 16#99#, 16#20#, 16#96#, 16#82#
   );
   FIPS_48  : constant Byte_Seq := (
      16#e1#, 16#dc#, 16#72#, 16#4d#, 16#56#, 16#21#
   );
   FIPS_56  : constant Byte_Seq := (
      16#06#, 16#e0#, 16#76#, 16#f5#, 16#a4#, 16#42#, 16#d5#
   );
   FIPS_64  : constant Byte_Seq := (
      16#57#, 16#38#, 16#c9#, 16#29#, 16#c4#, 16#f4#, 16#cc#, 16#b6#
   );
   FIPS_72  : constant Byte_Seq := (
      16#33#, 16#34#, 16#c5#, 16#80#, 16#75#, 16#d3#, 16#f4#, 16#13#,
      16#9e#
   );
   FIPS_80  : constant Byte_Seq := (
      16#74#, 16#cb#, 16#93#, 16#81#, 16#d8#, 16#9f#, 16#5a#, 16#a7#,
      16#33#, 16#68#
   );
   FIPS_88  : constant Byte_Seq := (
      16#76#, 16#ed#, 16#24#, 16#a0#, 16#f4#, 16#0a#, 16#41#, 16#22#,
      16#1e#, 16#bf#, 16#cf#
   );
   FIPS_96  : constant Byte_Seq := (
      16#9b#, 16#af#, 16#69#, 16#cb#, 16#a3#, 16#17#, 16#f4#, 16#22#,
      16#fe#, 16#26#, 16#a9#, 16#a0#
   );
   FIPS_104  : constant Byte_Seq := (
      16#68#, 16#51#, 16#1c#, 16#db#, 16#2d#, 16#bb#, 16#f3#, 16#53#,
      16#0d#, 16#7f#, 16#b6#, 16#1c#, 16#bc#
   );
   FIPS_112  : constant Byte_Seq := (
      16#af#, 16#39#, 16#7a#, 16#8b#, 16#8d#, 16#d7#, 16#3a#, 16#b7#,
      16#02#, 16#ce#, 16#8e#, 16#53#, 16#aa#, 16#9f#
   );
   FIPS_120  : constant Byte_Seq := (
      16#29#, 16#4a#, 16#f4#, 16#80#, 16#2e#, 16#5e#, 16#92#, 16#5e#,
      16#b1#, 16#c6#, 16#cc#, 16#9c#, 16#72#, 16#4f#, 16#09#
   );
   FIPS_128  : constant Byte_Seq := (
      16#0a#, 16#27#, 16#84#, 16#7c#, 16#dc#, 16#98#, 16#bd#, 16#6f#,
      16#62#, 16#22#, 16#0b#, 16#04#, 16#6e#, 16#dd#, 16#76#, 16#2b#
   );
   FIPS_136  : constant Byte_Seq := (
      16#1b#, 16#50#, 16#3f#, 16#b9#, 16#a7#, 16#3b#, 16#16#, 16#ad#,
      16#a3#, 16#fc#, 16#f1#, 16#04#, 16#26#, 16#23#, 16#ae#, 16#76#,
      16#10#
   );
   FIPS_144  : constant Byte_Seq := (
      16#59#, 16#eb#, 16#45#, 16#bb#, 16#be#, 16#b0#, 16#54#, 16#b0#,
      16#b9#, 16#73#, 16#34#, 16#d5#, 16#35#, 16#80#, 16#ce#, 16#03#,
      16#f6#, 16#99#
   );
   FIPS_152  : constant Byte_Seq := (
      16#58#, 16#e5#, 16#a3#, 16#25#, 16#9c#, 16#b0#, 16#b6#, 16#d1#,
      16#2c#, 16#83#, 16#f7#, 16#23#, 16#37#, 16#9e#, 16#35#, 16#fd#,
      16#29#, 16#8b#, 16#60#
   );
   FIPS_160  : constant Byte_Seq := (
      16#c1#, 16#ef#, 16#39#, 16#ce#, 16#e5#, 16#8e#, 16#78#, 16#f6#,
      16#fc#, 16#dc#, 16#12#, 16#e0#, 16#58#, 16#b7#, 16#f9#, 16#02#,
      16#ac#, 16#d1#, 16#a9#, 16#3b#
   );
   FIPS_168  : constant Byte_Seq := (
      16#9c#, 16#ab#, 16#7d#, 16#7d#, 16#ca#, 16#ec#, 16#98#, 16#cb#,
      16#3a#, 16#c6#, 16#c6#, 16#4d#, 16#d5#, 16#d4#, 16#47#, 16#0d#,
      16#0b#, 16#10#, 16#3a#, 16#81#, 16#0c#
   );
   FIPS_176  : constant Byte_Seq := (
      16#ea#, 16#15#, 16#7c#, 16#02#, 16#eb#, 16#af#, 16#1b#, 16#22#,
      16#de#, 16#22#, 16#1b#, 16#53#, 16#f2#, 16#35#, 16#39#, 16#36#,
      16#d2#, 16#35#, 16#9d#, 16#1e#, 16#1c#, 16#97#
   );
   FIPS_184  : constant Byte_Seq := (
      16#da#, 16#99#, 16#9b#, 16#c1#, 16#f9#, 16#c7#, 16#ac#, 16#ff#,
      16#32#, 16#82#, 16#8a#, 16#73#, 16#e6#, 16#72#, 16#d0#, 16#a4#,
      16#92#, 16#f6#, 16#ee#, 16#89#, 16#5c#, 16#68#, 16#67#
   );
   FIPS_192  : constant Byte_Seq := (
      16#47#, 16#99#, 16#13#, 16#01#, 16#15#, 16#6d#, 16#1d#, 16#97#,
      16#7c#, 16#03#, 16#38#, 16#ef#, 16#bc#, 16#ad#, 16#41#, 16#00#,
      16#41#, 16#33#, 16#ae#, 16#fb#, 16#ca#, 16#6b#, 16#cf#, 16#7e#
   );
   FIPS_200  : constant Byte_Seq := (
      16#2e#, 16#7e#, 16#a8#, 16#4d#, 16#a4#, 16#bc#, 16#4d#, 16#7c#,
      16#fb#, 16#46#, 16#3e#, 16#3f#, 16#2c#, 16#86#, 16#47#, 16#05#,
      16#7a#, 16#ff#, 16#f3#, 16#fb#, 16#ec#, 16#ec#, 16#a1#, 16#d2#,
      16#00#
   );
   FIPS_208  : constant Byte_Seq := (
      16#47#, 16#c7#, 16#70#, 16#eb#, 16#45#, 16#49#, 16#b6#, 16#ef#,
      16#f6#, 16#38#, 16#1d#, 16#62#, 16#e9#, 16#be#, 16#b4#, 16#64#,
      16#cd#, 16#98#, 16#d3#, 16#41#, 16#cc#, 16#1c#, 16#09#, 16#98#,
      16#1a#, 16#7a#
   );
   FIPS_216  : constant Byte_Seq := (
      16#ac#, 16#4c#, 16#26#, 16#d8#, 16#b4#, 16#3b#, 16#85#, 16#79#,
      16#d8#, 16#f6#, 16#1c#, 16#98#, 16#07#, 16#02#, 16#6e#, 16#83#,
      16#e9#, 16#b5#, 16#86#, 16#e1#, 16#15#, 16#9b#, 16#d4#, 16#3b#,
      16#85#, 16#19#, 16#37#
   );
   FIPS_224  : constant Byte_Seq := (
      16#07#, 16#77#, 16#fc#, 16#1e#, 16#1c#, 16#a4#, 16#73#, 16#04#,
      16#c2#, 16#e2#, 16#65#, 16#69#, 16#28#, 16#38#, 16#10#, 16#9e#,
      16#26#, 16#aa#, 16#b9#, 16#e5#, 16#c4#, 16#ae#, 16#4e#, 16#86#,
      16#00#, 16#df#, 16#4b#, 16#1f#
   );
   FIPS_232  : constant Byte_Seq := (
      16#1a#, 16#57#, 16#25#, 16#1c#, 16#43#, 16#1d#, 16#4e#, 16#6c#,
      16#2e#, 16#06#, 16#d6#, 16#52#, 16#46#, 16#a2#, 16#96#, 16#91#,
      16#50#, 16#71#, 16#a5#, 16#31#, 16#42#, 16#5e#, 16#cf#, 16#25#,
      16#59#, 16#89#, 16#42#, 16#2a#, 16#66#
   );
   FIPS_240  : constant Byte_Seq := (
      16#9b#, 16#24#, 16#5f#, 16#da#, 16#d9#, 16#ba#, 16#eb#, 16#89#,
      16#0d#, 16#9c#, 16#0d#, 16#0e#, 16#ff#, 16#81#, 16#6e#, 16#fb#,
      16#4c#, 16#a1#, 16#38#, 16#61#, 16#0b#, 16#c7#, 16#d7#, 16#8c#,
      16#b1#, 16#a8#, 16#01#, 16#ed#, 16#32#, 16#73#
   );
   FIPS_248  : constant Byte_Seq := (
      16#95#, 16#a7#, 16#65#, 16#80#, 16#9c#, 16#af#, 16#30#, 16#ad#,
      16#a9#, 16#0a#, 16#d6#, 16#d6#, 16#1c#, 16#2b#, 16#4b#, 16#30#,
      16#25#, 16#0d#, 16#f0#, 16#a7#, 16#ce#, 16#23#, 16#b7#, 16#75#,
      16#3c#, 16#91#, 16#87#, 16#f4#, 16#31#, 16#9c#, 16#e2#
   );
   FIPS_256  : constant Byte_Seq := (
      16#09#, 16#fc#, 16#1a#, 16#cc#, 16#c2#, 16#30#, 16#a2#, 16#05#,
      16#e4#, 16#a2#, 16#08#, 16#e6#, 16#4a#, 16#8f#, 16#20#, 16#42#,
      16#91#, 16#f5#, 16#81#, 16#a1#, 16#27#, 16#56#, 16#39#, 16#2d#,
      16#a4#, 16#b8#, 16#c0#, 16#cf#, 16#5e#, 16#f0#, 16#2b#, 16#95#
   );
   FIPS_264  : constant Byte_Seq := (
      16#05#, 16#46#, 16#f7#, 16#b8#, 16#68#, 16#2b#, 16#5b#, 16#95#,
      16#fd#, 16#32#, 16#38#, 16#5f#, 16#af#, 16#25#, 16#85#, 16#4c#,
      16#b3#, 16#f7#, 16#b4#, 16#0c#, 16#c8#, 16#fa#, 16#22#, 16#9f#,
      16#bd#, 16#52#, 16#b1#, 16#69#, 16#34#, 16#aa#, 16#b3#, 16#88#,
      16#a7#
   );
   FIPS_272  : constant Byte_Seq := (
      16#b1#, 16#2d#, 16#b4#, 16#a1#, 16#02#, 16#55#, 16#29#, 16#b3#,
      16#b7#, 16#b1#, 16#e4#, 16#5c#, 16#6d#, 16#bc#, 16#7b#, 16#aa#,
      16#88#, 16#97#, 16#a0#, 16#57#, 16#6e#, 16#66#, 16#f6#, 16#4b#,
      16#f3#, 16#f8#, 16#23#, 16#61#, 16#13#, 16#a6#, 16#27#, 16#6e#,
      16#e7#, 16#7d#
   );
   FIPS_280  : constant Byte_Seq := (
      16#e6#, 16#8c#, 16#b6#, 16#d8#, 16#c1#, 16#86#, 16#6c#, 16#0a#,
      16#71#, 16#e7#, 16#31#, 16#3f#, 16#83#, 16#dc#, 16#11#, 16#a5#,
      16#80#, 16#9c#, 16#f5#, 16#cf#, 16#be#, 16#ed#, 16#1a#, 16#58#,
      16#7c#, 16#e9#, 16#c2#, 16#c9#, 16#2e#, 16#02#, 16#2a#, 16#bc#,
      16#16#, 16#44#, 16#bb#
   );
   FIPS_288  : constant Byte_Seq := (
      16#4e#, 16#3d#, 16#8a#, 16#c3#, 16#6d#, 16#61#, 16#d9#, 16#e5#,
      16#14#, 16#80#, 16#83#, 16#11#, 16#55#, 16#b2#, 16#53#, 16#b3#,
      16#79#, 16#69#, 16#fe#, 16#7e#, 16#f4#, 16#9d#, 16#b3#, 16#b3#,
      16#99#, 16#26#, 16#f3#, 16#a0#, 16#0b#, 16#69#, 16#a3#, 16#67#,
      16#74#, 16#36#, 16#60#, 16#00#
   );
   FIPS_296  : constant Byte_Seq := (
      16#03#, 16#b2#, 16#64#, 16#be#, 16#51#, 16#e4#, 16#b9#, 16#41#,
      16#86#, 16#4f#, 16#9b#, 16#70#, 16#b4#, 16#c9#, 16#58#, 16#f5#,
      16#35#, 16#5a#, 16#ac#, 16#29#, 16#4b#, 16#4b#, 16#87#, 16#cb#,
      16#03#, 16#7f#, 16#11#, 16#f8#, 16#5f#, 16#07#, 16#eb#, 16#57#,
      16#b3#, 16#f0#, 16#b8#, 16#95#, 16#50#
   );
   FIPS_304  : constant Byte_Seq := (
      16#d0#, 16#fe#, 16#fd#, 16#96#, 16#78#, 16#7c#, 16#65#, 16#ff#,
      16#a7#, 16#f9#, 16#10#, 16#d6#, 16#d0#, 16#ad#, 16#a6#, 16#3d#,
      16#64#, 16#d5#, 16#c4#, 16#67#, 16#99#, 16#60#, 16#e7#, 16#f0#,
      16#6a#, 16#eb#, 16#8c#, 16#70#, 16#df#, 16#ef#, 16#95#, 16#4f#,
      16#8e#, 16#39#, 16#ef#, 16#db#, 16#62#, 16#9b#
   );
   FIPS_312  : constant Byte_Seq := (
      16#b7#, 16#c7#, 16#9d#, 16#7e#, 16#5f#, 16#1e#, 16#ec#, 16#cd#,
      16#fe#, 16#df#, 16#0e#, 16#7b#, 16#f4#, 16#3e#, 16#73#, 16#0d#,
      16#44#, 16#7e#, 16#60#, 16#7d#, 16#8d#, 16#14#, 16#89#, 16#82#,
      16#3d#, 16#09#, 16#e1#, 16#12#, 16#01#, 16#a0#, 16#b1#, 16#25#,
      16#80#, 16#39#, 16#e7#, 16#bd#, 16#48#, 16#75#, 16#b1#
   );
   FIPS_320  : constant Byte_Seq := (
      16#64#, 16#cd#, 16#36#, 16#3e#, 16#cc#, 16#e0#, 16#5f#, 16#df#,
      16#da#, 16#24#, 16#86#, 16#d0#, 16#11#, 16#a3#, 16#db#, 16#95#,
      16#b5#, 16#20#, 16#6a#, 16#19#, 16#d3#, 16#05#, 16#40#, 16#46#,
      16#81#, 16#9d#, 16#d0#, 16#d3#, 16#67#, 16#83#, 16#95#, 16#5d#,
      16#7e#, 16#5b#, 16#f8#, 16#ba#, 16#18#, 16#bf#, 16#73#, 16#8a#
   );
   FIPS_328  : constant Byte_Seq := (
      16#6a#, 16#c6#, 16#c6#, 16#3d#, 16#61#, 16#8e#, 16#af#, 16#00#,
      16#d9#, 16#1c#, 16#5e#, 16#28#, 16#07#, 16#e8#, 16#3c#, 16#09#,
      16#39#, 16#12#, 16#b8#, 16#e2#, 16#02#, 16#f7#, 16#8e#, 16#13#,
      16#97#, 16#03#, 16#49#, 16#8a#, 16#79#, 16#c6#, 16#06#, 16#7f#,
      16#54#, 16#49#, 16#7c#, 16#61#, 16#27#, 16#a2#, 16#39#, 16#10#,
      16#a6#
   );
   FIPS_336  : constant Byte_Seq := (
      16#d2#, 16#68#, 16#26#, 16#db#, 16#9b#, 16#ae#, 16#aa#, 16#89#,
      16#26#, 16#91#, 16#b6#, 16#89#, 16#00#, 16#b9#, 16#61#, 16#63#,
      16#20#, 16#8e#, 16#80#, 16#6a#, 16#1d#, 16#a0#, 16#77#, 16#42#,
      16#9e#, 16#45#, 16#4f#, 16#a0#, 16#11#, 16#84#, 16#09#, 16#51#,
      16#a0#, 16#31#, 16#32#, 16#7e#, 16#60#, 16#5a#, 16#b8#, 16#2e#,
      16#cc#, 16#e2#
   );
   FIPS_344  : constant Byte_Seq := (
      16#3f#, 16#7a#, 16#05#, 16#9b#, 16#65#, 16#d6#, 16#cb#, 16#02#,
      16#49#, 16#20#, 16#4a#, 16#ac#, 16#10#, 16#b9#, 16#f1#, 16#a4#,
      16#ac#, 16#9e#, 16#58#, 16#68#, 16#ad#, 16#eb#, 16#be#, 16#93#,
      16#5a#, 16#9e#, 16#b5#, 16#b9#, 16#01#, 16#9e#, 16#1c#, 16#93#,
      16#8b#, 16#fc#, 16#4e#, 16#5c#, 16#53#, 16#78#, 16#99#, 16#7a#,
      16#39#, 16#47#, 16#f2#
   );
   FIPS_352  : constant Byte_Seq := (
      16#60#, 16#ff#, 16#cb#, 16#23#, 16#d6#, 16#b8#, 16#8e#, 16#48#,
      16#5b#, 16#92#, 16#0a#, 16#f8#, 16#1d#, 16#10#, 16#83#, 16#f6#,
      16#29#, 16#1d#, 16#06#, 16#ac#, 16#8c#, 16#a3#, 16#a9#, 16#65#,
      16#b8#, 16#59#, 16#14#, 16#bc#, 16#2a#, 16#dd#, 16#40#, 16#54#,
      16#4a#, 16#02#, 16#7f#, 16#ca#, 16#93#, 16#6b#, 16#bd#, 16#e8#,
      16#f3#, 16#59#, 16#05#, 16#1c#
   );
   FIPS_360  : constant Byte_Seq := (
      16#9e#, 16#cd#, 16#07#, 16#b6#, 16#84#, 16#bb#, 16#9e#, 16#0e#,
      16#66#, 16#92#, 16#e3#, 16#20#, 16#ce#, 16#c4#, 16#51#, 16#0c#,
      16#a7#, 16#9f#, 16#cd#, 16#b3#, 16#a2#, 16#21#, 16#2c#, 16#26#,
      16#d9#, 16#0d#, 16#f6#, 16#5d#, 16#b3#, 16#3e#, 16#69#, 16#2d#,
      16#07#, 16#3c#, 16#c1#, 16#74#, 16#84#, 16#0d#, 16#b7#, 16#97#,
      16#50#, 16#4e#, 16#48#, 16#2e#, 16#ef#
   );
   FIPS_368  : constant Byte_Seq := (
      16#9d#, 16#64#, 16#de#, 16#71#, 16#61#, 16#89#, 16#58#, 16#84#,
      16#e7#, 16#fa#, 16#3d#, 16#6e#, 16#9e#, 16#b9#, 16#96#, 16#e7#,
      16#eb#, 16#e5#, 16#11#, 16#b0#, 16#1f#, 16#e1#, 16#9c#, 16#d4#,
      16#a6#, 16#b3#, 16#32#, 16#2e#, 16#80#, 16#aa#, 16#f5#, 16#2b#,
      16#f6#, 16#44#, 16#7e#, 16#d1#, 16#85#, 16#4e#, 16#71#, 16#00#,
      16#1f#, 16#4d#, 16#54#, 16#f8#, 16#93#, 16#1d#
   );
   FIPS_376  : constant Byte_Seq := (
      16#c4#, 16#ad#, 16#3c#, 16#5e#, 16#78#, 16#d9#, 16#17#, 16#ec#,
      16#b0#, 16#cb#, 16#bc#, 16#d1#, 16#c4#, 16#81#, 16#fc#, 16#2a#,
      16#af#, 16#23#, 16#2f#, 16#7e#, 16#28#, 16#97#, 16#79#, 16#f4#,
      16#0e#, 16#50#, 16#4c#, 16#c3#, 16#09#, 16#66#, 16#2e#, 16#e9#,
      16#6f#, 16#ec#, 16#bd#, 16#20#, 16#64#, 16#7e#, 16#f0#, 16#0e#,
      16#46#, 16#19#, 16#9f#, 16#bc#, 16#48#, 16#2f#, 16#46#
   );
   FIPS_384  : constant Byte_Seq := (
      16#4e#, 16#ef#, 16#51#, 16#07#, 16#45#, 16#9b#, 16#dd#, 16#f8#,
      16#f2#, 16#4f#, 16#c7#, 16#65#, 16#6f#, 16#d4#, 16#89#, 16#6d#,
      16#a8#, 16#71#, 16#1d#, 16#b5#, 16#04#, 16#00#, 16#c0#, 16#16#,
      16#48#, 16#47#, 16#f6#, 16#92#, 16#b8#, 16#86#, 16#ce#, 16#8d#,
      16#7f#, 16#4d#, 16#67#, 16#39#, 16#50#, 16#90#, 16#b3#, 16#53#,
      16#4e#, 16#fd#, 16#7b#, 16#0d#, 16#29#, 16#8d#, 16#a3#, 16#4b#
   );
   FIPS_392  : constant Byte_Seq := (
      16#04#, 16#7d#, 16#27#, 16#58#, 16#e7#, 16#c2#, 16#c9#, 16#62#,
      16#3f#, 16#9b#, 16#db#, 16#93#, 16#b6#, 16#59#, 16#7c#, 16#5e#,
      16#84#, 16#a0#, 16#cd#, 16#34#, 16#e6#, 16#10#, 16#01#, 16#4b#,
      16#cb#, 16#25#, 16#b4#, 16#9e#, 16#d0#, 16#5c#, 16#7e#, 16#35#,
      16#6e#, 16#98#, 16#c7#, 16#a6#, 16#72#, 16#c3#, 16#dd#, 16#dc#,
      16#ae#, 16#b8#, 16#43#, 16#17#, 16#ef#, 16#61#, 16#4d#, 16#34#,
      16#2f#
   );
   FIPS_400  : constant Byte_Seq := (
      16#3d#, 16#83#, 16#df#, 16#37#, 16#17#, 16#2c#, 16#81#, 16#af#,
      16#d0#, 16#de#, 16#11#, 16#51#, 16#39#, 16#fb#, 16#f4#, 16#39#,
      16#0c#, 16#22#, 16#e0#, 16#98#, 16#c5#, 16#af#, 16#4c#, 16#5a#,
      16#b4#, 16#85#, 16#24#, 16#06#, 16#51#, 16#0b#, 16#c0#, 16#e6#,
      16#cf#, 16#74#, 16#17#, 16#69#, 16#f4#, 16#44#, 16#30#, 16#c5#,
      16#27#, 16#0f#, 16#da#, 16#e0#, 16#cb#, 16#84#, 16#9d#, 16#71#,
      16#cb#, 16#ab#
   );
   FIPS_408  : constant Byte_Seq := (
      16#33#, 16#fd#, 16#9b#, 16#c1#, 16#7e#, 16#2b#, 16#27#, 16#1f#,
      16#a0#, 16#4c#, 16#6b#, 16#93#, 16#c0#, 16#bd#, 16#ea#, 16#e9#,
      16#86#, 16#54#, 16#a7#, 16#68#, 16#2d#, 16#31#, 16#d9#, 16#b4#,
      16#da#, 16#b7#, 16#e6#, 16#f3#, 16#2c#, 16#d5#, 16#8f#, 16#2f#,
      16#14#, 16#8a#, 16#68#, 16#fb#, 16#e7#, 16#a8#, 16#8c#, 16#5a#,
      16#b1#, 16#d8#, 16#8e#, 16#dc#, 16#cd#, 16#de#, 16#b3#, 16#0a#,
      16#b2#, 16#1e#, 16#5e#
   );
   FIPS_416  : constant Byte_Seq := (
      16#77#, 16#a8#, 16#79#, 16#cf#, 16#a1#, 16#1d#, 16#7f#, 16#ca#,
      16#c7#, 16#a8#, 16#28#, 16#2c#, 16#c3#, 16#8a#, 16#43#, 16#dc#,
      16#f3#, 16#76#, 16#43#, 16#cc#, 16#90#, 16#98#, 16#37#, 16#21#,
      16#3b#, 16#d6#, 16#fd#, 16#95#, 16#d9#, 16#56#, 16#b2#, 16#19#,
      16#a1#, 16#40#, 16#6c#, 16#be#, 16#73#, 16#c5#, 16#2c#, 16#d5#,
      16#6c#, 16#60#, 16#0e#, 16#55#, 16#b7#, 16#5b#, 16#c3#, 16#7e#,
      16#a6#, 16#96#, 16#41#, 16#bc#
   );
   FIPS_424  : constant Byte_Seq := (
      16#45#, 16#a3#, 16#e6#, 16#b8#, 16#65#, 16#27#, 16#f2#, 16#0b#,
      16#45#, 16#37#, 16#f5#, 16#af#, 16#96#, 16#cf#, 16#c5#, 16#ad#,
      16#87#, 16#77#, 16#a2#, 16#dd#, 16#e6#, 16#cf#, 16#75#, 16#11#,
      16#88#, 16#6c#, 16#55#, 16#90#, 16#ec#, 16#e2#, 16#4f#, 16#c6#,
      16#1b#, 16#22#, 16#67#, 16#39#, 16#d2#, 16#07#, 16#da#, 16#bf#,
      16#e3#, 16#2b#, 16#a6#, 16#ef#, 16#d9#, 16#ff#, 16#4c#, 16#d5#,
      16#db#, 16#1b#, 16#d5#, 16#ea#, 16#d3#
   );
   FIPS_432  : constant Byte_Seq := (
      16#25#, 16#36#, 16#2a#, 16#4b#, 16#9d#, 16#74#, 16#bd#, 16#e6#,
      16#12#, 16#8c#, 16#4f#, 16#dc#, 16#67#, 16#23#, 16#05#, 16#90#,
      16#09#, 16#47#, 16#bc#, 16#3a#, 16#da#, 16#9d#, 16#9d#, 16#31#,
      16#6e#, 16#bc#, 16#f1#, 16#66#, 16#7a#, 16#d4#, 16#36#, 16#31#,
      16#89#, 16#93#, 16#72#, 16#51#, 16#f1#, 16#49#, 16#c7#, 16#2e#,
      16#06#, 16#4a#, 16#48#, 16#60#, 16#8d#, 16#94#, 16#0b#, 16#75#,
      16#74#, 16#b1#, 16#7f#, 16#ef#, 16#c0#, 16#df#
   );
   FIPS_440  : constant Byte_Seq := (
      16#3e#, 16#bf#, 16#b0#, 16#6d#, 16#b8#, 16#c3#, 16#8d#, 16#5b#,
      16#a0#, 16#37#, 16#f1#, 16#36#, 16#3e#, 16#11#, 16#85#, 16#50#,
      16#aa#, 16#d9#, 16#46#, 16#06#, 16#e2#, 16#68#, 16#35#, 16#a0#,
      16#1a#, 16#f0#, 16#50#, 16#78#, 16#53#, 16#3c#, 16#c2#, 16#5f#,
      16#2f#, 16#39#, 16#57#, 16#3c#, 16#04#, 16#b6#, 16#32#, 16#f6#,
      16#2f#, 16#68#, 16#c2#, 16#94#, 16#ab#, 16#31#, 16#f2#, 16#a3#,
      16#e2#, 16#a1#, 16#a0#, 16#d8#, 16#c2#, 16#be#, 16#51#
   );
   FIPS_448  : constant Byte_Seq := (
      16#2d#, 16#52#, 16#44#, 16#7d#, 16#12#, 16#44#, 16#d2#, 16#eb#,
      16#c2#, 16#86#, 16#50#, 16#e7#, 16#b0#, 16#56#, 16#54#, 16#ba#,
      16#d3#, 16#5b#, 16#3a#, 16#68#, 16#ee#, 16#dc#, 16#7f#, 16#85#,
      16#15#, 16#30#, 16#6b#, 16#49#, 16#6d#, 16#75#, 16#f3#, 16#e7#,
      16#33#, 16#85#, 16#dd#, 16#1b#, 16#00#, 16#26#, 16#25#, 16#02#,
      16#4b#, 16#81#, 16#a0#, 16#2f#, 16#2f#, 16#d6#, 16#df#, 16#fb#,
      16#6e#, 16#6d#, 16#56#, 16#1c#, 16#b7#, 16#d0#, 16#bd#, 16#7a#
   );
   FIPS_456  : constant Byte_Seq := (
      16#4c#, 16#ac#, 16#e4#, 16#22#, 16#e4#, 16#a0#, 16#15#, 16#a7#,
      16#54#, 16#92#, 16#b3#, 16#b3#, 16#bb#, 16#fb#, 16#df#, 16#37#,
      16#58#, 16#ea#, 16#ff#, 16#4f#, 16#e5#, 16#04#, 16#b4#, 16#6a#,
      16#26#, 16#c9#, 16#0d#, 16#ac#, 16#c1#, 16#19#, 16#fa#, 16#90#,
      16#50#, 16#f6#, 16#03#, 16#d2#, 16#b5#, 16#8b#, 16#39#, 16#8c#,
      16#ad#, 16#6d#, 16#6d#, 16#9f#, 16#a9#, 16#22#, 16#a1#, 16#54#,
      16#d9#, 16#e0#, 16#bc#, 16#43#, 16#89#, 16#96#, 16#82#, 16#74#,
      16#b0#
   );
   FIPS_464  : constant Byte_Seq := (
      16#86#, 16#20#, 16#b8#, 16#6f#, 16#bc#, 16#aa#, 16#ce#, 16#4f#,
      16#f3#, 16#c2#, 16#92#, 16#1b#, 16#84#, 16#66#, 16#dd#, 16#d7#,
      16#ba#, 16#ca#, 16#e0#, 16#7e#, 16#ef#, 16#ef#, 16#69#, 16#3c#,
      16#f1#, 16#77#, 16#62#, 16#dc#, 16#ab#, 16#b8#, 16#9a#, 16#84#,
      16#01#, 16#0f#, 16#c9#, 16#a0#, 16#fb#, 16#76#, 16#ce#, 16#1c#,
      16#26#, 16#59#, 16#3a#, 16#d6#, 16#37#, 16#a6#, 16#12#, 16#53#,
      16#f2#, 16#24#, 16#d1#, 16#b1#, 16#4a#, 16#05#, 16#ad#, 16#dc#,
      16#ca#, 16#be#
   );
   FIPS_472  : constant Byte_Seq := (
      16#d1#, 16#be#, 16#3f#, 16#13#, 16#fe#, 16#ba#, 16#fe#, 16#fc#,
      16#14#, 16#41#, 16#4d#, 16#9f#, 16#b7#, 16#f6#, 16#93#, 16#db#,
      16#16#, 16#dc#, 16#1a#, 16#e2#, 16#70#, 16#c5#, 16#b6#, 16#47#,
      16#d8#, 16#0d#, 16#a8#, 16#58#, 16#35#, 16#87#, 16#c1#, 16#ad#,
      16#8c#, 16#b8#, 16#cb#, 16#01#, 16#82#, 16#43#, 16#24#, 16#41#,
      16#1c#, 16#a5#, 16#ac#, 16#e3#, 16#ca#, 16#22#, 16#e1#, 16#79#,
      16#a4#, 16#ff#, 16#49#, 16#86#, 16#f3#, 16#f2#, 16#11#, 16#90#,
      16#f3#, 16#d7#, 16#f3#
   );
   FIPS_480  : constant Byte_Seq := (
      16#f4#, 16#99#, 16#cc#, 16#3f#, 16#6e#, 16#3c#, 16#f7#, 16#c3#,
      16#12#, 16#ff#, 16#df#, 16#ba#, 16#61#, 16#b1#, 16#26#, 16#0c#,
      16#37#, 16#12#, 16#9c#, 16#1a#, 16#fb#, 16#39#, 16#10#, 16#47#,
      16#19#, 16#33#, 16#67#, 16#b7#, 16#b2#, 16#ed#, 16#eb#, 16#57#,
      16#92#, 16#53#, 16#e5#, 16#1d#, 16#62#, 16#ba#, 16#6d#, 16#91#,
      16#1e#, 16#7b#, 16#81#, 16#8c#, 16#ca#, 16#e1#, 16#55#, 16#3f#,
      16#61#, 16#46#, 16#ea#, 16#78#, 16#0f#, 16#78#, 16#e2#, 16#21#,
      16#9f#, 16#62#, 16#93#, 16#09#
   );
   FIPS_488  : constant Byte_Seq := (
      16#6d#, 16#d6#, 16#ef#, 16#d6#, 16#f6#, 16#ca#, 16#a6#, 16#3b#,
      16#72#, 16#9a#, 16#a8#, 16#18#, 16#6e#, 16#30#, 16#8b#, 16#c1#,
      16#bd#, 16#a0#, 16#63#, 16#07#, 16#c0#, 16#5a#, 16#2c#, 16#0a#,
      16#e5#, 16#a3#, 16#68#, 16#4e#, 16#6e#, 16#46#, 16#08#, 16#11#,
      16#74#, 16#86#, 16#90#, 16#dc#, 16#2b#, 16#58#, 16#77#, 16#59#,
      16#67#, 16#cf#, 16#cc#, 16#64#, 16#5f#, 16#d8#, 16#20#, 16#64#,
      16#b1#, 16#27#, 16#9f#, 16#dc#, 16#a7#, 16#71#, 16#80#, 16#3d#,
      16#b9#, 16#dc#, 16#a0#, 16#ff#, 16#53#
   );
   FIPS_496  : constant Byte_Seq := (
      16#65#, 16#11#, 16#a2#, 16#24#, 16#2d#, 16#db#, 16#27#, 16#31#,
      16#78#, 16#e1#, 16#9a#, 16#82#, 16#c5#, 16#7c#, 16#85#, 16#cb#,
      16#05#, 16#a6#, 16#88#, 16#7f#, 16#f2#, 16#01#, 16#4c#, 16#f1#,
      16#a3#, 16#1c#, 16#b9#, 16#ba#, 16#5d#, 16#f1#, 16#69#, 16#5a#,
      16#ad#, 16#b2#, 16#5c#, 16#22#, 16#b3#, 16#c5#, 16#ed#, 16#51#,
      16#c1#, 16#0d#, 16#04#, 16#7d#, 16#25#, 16#6b#, 16#8e#, 16#34#,
      16#42#, 16#84#, 16#2a#, 16#e4#, 16#e6#, 16#c5#, 16#25#, 16#f8#,
      16#d7#, 16#a5#, 16#a9#, 16#44#, 16#af#, 16#2a#
   );
   FIPS_504  : constant Byte_Seq := (
      16#e2#, 16#f7#, 16#6e#, 16#97#, 16#60#, 16#6a#, 16#87#, 16#2e#,
      16#31#, 16#74#, 16#39#, 16#f1#, 16#a0#, 16#3f#, 16#cd#, 16#92#,
      16#e6#, 16#32#, 16#e5#, 16#bd#, 16#4e#, 16#7c#, 16#bc#, 16#4e#,
      16#97#, 16#f1#, 16#af#, 16#c1#, 16#9a#, 16#16#, 16#fd#, 16#e9#,
      16#2d#, 16#77#, 16#cb#, 16#e5#, 16#46#, 16#41#, 16#6b#, 16#51#,
      16#64#, 16#0c#, 16#dd#, 16#b9#, 16#2a#, 16#f9#, 16#96#, 16#53#,
      16#4d#, 16#fd#, 16#81#, 16#ed#, 16#b1#, 16#7c#, 16#44#, 16#24#,
      16#cf#, 16#1a#, 16#c4#, 16#d7#, 16#5a#, 16#ce#, 16#eb#
   );
   FIPS_512  : constant Byte_Seq := (
      16#5a#, 16#86#, 16#b7#, 16#37#, 16#ea#, 16#ea#, 16#8e#, 16#e9#,
      16#76#, 16#a0#, 16#a2#, 16#4d#, 16#a6#, 16#3e#, 16#7e#, 16#d7#,
      16#ee#, 16#fa#, 16#d1#, 16#8a#, 16#10#, 16#1c#, 16#12#, 16#11#,
      16#e2#, 16#b3#, 16#65#, 16#0c#, 16#51#, 16#87#, 16#c2#, 16#a8#,
      16#a6#, 16#50#, 16#54#, 16#72#, 16#08#, 16#25#, 16#1f#, 16#6d#,
      16#42#, 16#37#, 16#e6#, 16#61#, 16#c7#, 16#bf#, 16#4c#, 16#77#,
      16#f3#, 16#35#, 16#39#, 16#03#, 16#94#, 16#c3#, 16#7f#, 16#a1#,
      16#a9#, 16#f9#, 16#be#, 16#83#, 16#6a#, 16#c2#, 16#85#, 16#09#
   );
 begin
   Hash (R1, To_Byte_Seq (M1));
   DH ("FIPS 180-2 B.1 procedural API - Hash is", R1);

   --  Functional style interface
   R1 := Hash (To_Byte_Seq (M1));
   DH ("FIPS 180-2 B.1 functional API - Hash is", R1);

   Hash (R1, To_Byte_Seq (M2));
   DH ("FIPS 180-2 B.2 procedural API - Hash is", R1);

   Hash (R1, To_Byte_Seq (M3));
   DH ("FIPS 180-2 B.3 procedural API - Hash is", R1);

   Hash (R1, FIPS_0);
   DH ("FIPS 180-4 len 0 procedural API - Hash is", R1);

   Hash (R1, FIPS_8);
   DH ("FIPS 180-4 len 8 procedural API - Hash is", R1);

   Hash (R1, FIPS_16);
   DH ("FIPS 180-4 len 16 procedural API - Hash is", R1);

   Hash (R1, FIPS_24);
   DH ("FIPS 180-4 len 24 procedural API - Hash is", R1);

   Hash (R1, FIPS_32);
   DH ("FIPS 180-4 len 32 procedural API - Hash is", R1);

   Hash (R1, FIPS_40);
   DH ("FIPS 180-4 len 40 procedural API - Hash is", R1);

   Hash (R1, FIPS_48);
   DH ("FIPS 180-4 len 48 procedural API - Hash is", R1);

   Hash (R1, FIPS_56);
   DH ("FIPS 180-4 len 56 procedural API - Hash is", R1);

   Hash (R1, FIPS_64);
   DH ("FIPS 180-4 len 64 procedural API - Hash is", R1);

   Hash (R1, FIPS_72);
   DH ("FIPS 180-4 len 72 procedural API - Hash is", R1);

   Hash (R1, FIPS_80);
   DH ("FIPS 180-4 len 80 procedural API - Hash is", R1);

   Hash (R1, FIPS_88);
   DH ("FIPS 180-4 len 88 procedural API - Hash is", R1);

   Hash (R1, FIPS_96);
   DH ("FIPS 180-4 len 96 procedural API - Hash is", R1);

   Hash (R1, FIPS_104);
   DH ("FIPS 180-4 len 104 procedural API - Hash is", R1);

   Hash (R1, FIPS_112);
   DH ("FIPS 180-4 len 112 procedural API - Hash is", R1);

   Hash (R1, FIPS_120);
   DH ("FIPS 180-4 len 120 procedural API - Hash is", R1);

   Hash (R1, FIPS_128);
   DH ("FIPS 180-4 len 128 procedural API - Hash is", R1);

   Hash (R1, FIPS_136);
   DH ("FIPS 180-4 len 136 procedural API - Hash is", R1);

   Hash (R1, FIPS_144);
   DH ("FIPS 180-4 len 144 procedural API - Hash is", R1);

   Hash (R1, FIPS_152);
   DH ("FIPS 180-4 len 152 procedural API - Hash is", R1);

   Hash (R1, FIPS_160);
   DH ("FIPS 180-4 len 160 procedural API - Hash is", R1);

   Hash (R1, FIPS_168);
   DH ("FIPS 180-4 len 168 procedural API - Hash is", R1);

   Hash (R1, FIPS_176);
   DH ("FIPS 180-4 len 176 procedural API - Hash is", R1);

   Hash (R1, FIPS_184);
   DH ("FIPS 180-4 len 184 procedural API - Hash is", R1);

   Hash (R1, FIPS_192);
   DH ("FIPS 180-4 len 192 procedural API - Hash is", R1);

   Hash (R1, FIPS_200);
   DH ("FIPS 180-4 len 200 procedural API - Hash is", R1);

   Hash (R1, FIPS_208);
   DH ("FIPS 180-4 len 208 procedural API - Hash is", R1);

   Hash (R1, FIPS_216);
   DH ("FIPS 180-4 len 216 procedural API - Hash is", R1);

   Hash (R1, FIPS_224);
   DH ("FIPS 180-4 len 224 procedural API - Hash is", R1);

   Hash (R1, FIPS_232);
   DH ("FIPS 180-4 len 232 procedural API - Hash is", R1);

   Hash (R1, FIPS_240);
   DH ("FIPS 180-4 len 240 procedural API - Hash is", R1);

   Hash (R1, FIPS_248);
   DH ("FIPS 180-4 len 248 procedural API - Hash is", R1);

   Hash (R1, FIPS_256);
   DH ("FIPS 180-4 len 256 procedural API - Hash is", R1);

   Hash (R1, FIPS_264);
   DH ("FIPS 180-4 len 264 procedural API - Hash is", R1);

   Hash (R1, FIPS_272);
   DH ("FIPS 180-4 len 272 procedural API - Hash is", R1);

   Hash (R1, FIPS_280);
   DH ("FIPS 180-4 len 280 procedural API - Hash is", R1);

   Hash (R1, FIPS_288);
   DH ("FIPS 180-4 len 288 procedural API - Hash is", R1);

   Hash (R1, FIPS_296);
   DH ("FIPS 180-4 len 296 procedural API - Hash is", R1);

   Hash (R1, FIPS_304);
   DH ("FIPS 180-4 len 304 procedural API - Hash is", R1);

   Hash (R1, FIPS_312);
   DH ("FIPS 180-4 len 312 procedural API - Hash is", R1);

   Hash (R1, FIPS_320);
   DH ("FIPS 180-4 len 320 procedural API - Hash is", R1);

   Hash (R1, FIPS_328);
   DH ("FIPS 180-4 len 328 procedural API - Hash is", R1);

   Hash (R1, FIPS_336);
   DH ("FIPS 180-4 len 336 procedural API - Hash is", R1);

   Hash (R1, FIPS_344);
   DH ("FIPS 180-4 len 344 procedural API - Hash is", R1);

   Hash (R1, FIPS_352);
   DH ("FIPS 180-4 len 352 procedural API - Hash is", R1);

   Hash (R1, FIPS_360);
   DH ("FIPS 180-4 len 360 procedural API - Hash is", R1);

   Hash (R1, FIPS_368);
   DH ("FIPS 180-4 len 368 procedural API - Hash is", R1);

   Hash (R1, FIPS_376);
   DH ("FIPS 180-4 len 376 procedural API - Hash is", R1);

   Hash (R1, FIPS_384);
   DH ("FIPS 180-4 len 384 procedural API - Hash is", R1);

   Hash (R1, FIPS_392);
   DH ("FIPS 180-4 len 392 procedural API - Hash is", R1);

   Hash (R1, FIPS_400);
   DH ("FIPS 180-4 len 400 procedural API - Hash is", R1);

   Hash (R1, FIPS_408);
   DH ("FIPS 180-4 len 408 procedural API - Hash is", R1);

   Hash (R1, FIPS_416);
   DH ("FIPS 180-4 len 416 procedural API - Hash is", R1);

   Hash (R1, FIPS_424);
   DH ("FIPS 180-4 len 424 procedural API - Hash is", R1);

   Hash (R1, FIPS_432);
   DH ("FIPS 180-4 len 432 procedural API - Hash is", R1);

   Hash (R1, FIPS_440);
   DH ("FIPS 180-4 len 440 procedural API - Hash is", R1);

   Hash (R1, FIPS_448);
   DH ("FIPS 180-4 len 448 procedural API - Hash is", R1);

   Hash (R1, FIPS_456);
   DH ("FIPS 180-4 len 456 procedural API - Hash is", R1);

   Hash (R1, FIPS_464);
   DH ("FIPS 180-4 len 464 procedural API - Hash is", R1);

   Hash (R1, FIPS_472);
   DH ("FIPS 180-4 len 472 procedural API - Hash is", R1);

   Hash (R1, FIPS_480);
   DH ("FIPS 180-4 len 480 procedural API - Hash is", R1);

   Hash (R1, FIPS_488);
   DH ("FIPS 180-4 len 488 procedural API - Hash is", R1);

   Hash (R1, FIPS_496);
   DH ("FIPS 180-4 len 496 procedural API - Hash is", R1);

   Hash (R1, FIPS_504);
   DH ("FIPS 180-4 len 504 procedural API - Hash is", R1);

   Hash (R1, FIPS_512);
   DH ("FIPS 180-4 len 512 procedural API - Hash is", R1);
end Hash1;
