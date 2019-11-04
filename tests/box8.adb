with SPARKNaCl;        use SPARKNaCl;
with Random;           use Random;

with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;      use Ada.Text_IO;
with Interfaces;       use Interfaces;

procedure Box8
is
   AliceSK, AlicePK, BobSK, BobPK : Bytes_32;
   N : Bytes_24;
   S, S2 : Boolean;
begin
--   for MLen in N32 range 0 .. 999 loop
   for MLen in N32 range 0 .. 99 loop
      Crypto_Box_Keypair (AlicePK, AliceSK);
      Crypto_Box_Keypair (BobPK, BobSK);
      Random_Bytes (N);
      Put ("Box8 - iteration" & MLen'Img);
      declare
         subtype Index is
           N32 range 0 .. Crypto_Box_Plaintext_Zero_Bytes + MLen - 1;
         subtype CIndex is
           N32 range Crypto_Box_Ciphertext_Zero_Bytes .. Index'Last;
         subtype Text is
           Byte_Seq (Index);
         package RI is new Ada.Numerics.Discrete_Random (CIndex);
         G : RI.Generator;
         M, C, M2 : Text := (others => 0);
      begin
         RI.Reset (G);
         Random_Bytes (M (Crypto_Box_Plaintext_Zero_Bytes .. M'Last));
         Crypto_Box (C, S, M, N, BobPK, AliceSK);
         if S then
            C (RI.Random (G)) := Random_Byte;
            Crypto_Box_Open (M2, S2, C, N, AlicePK, BobSK);
            if S2 then
               if not Equal (M, M2) then
                  Put_Line (" forgery!");
                  exit;
               else
                  Put_Line (" OK");
               end if;
            else
               Put_Line (" OK"); --  data corruption spotted OK
            end if;
         else
            Put_Line ("bad encryption");
         end if;
      end;
   end loop;
end Box8;
