package sl3p
with SPARK_Mode
is

    type unsigned_64 is mod 2**64;
    type unsigned_32 is mod 2**32;

    type Sl3p_header is record
        Sequence_number: unsigned_64;
        Length: unsigned_32;
    end record;

    Ethernet_frame_size : constant unsigned_32 := 14;
    Sl3p_frame_size : constant unsigned_32 := 12;

    function validate(header: Sl3p_header; Frame_length: unsigned_32; sequence_number: unsigned_64) return Boolean
      with
        Pre => Frame_length <= 1500 and Frame_length >= 60,
        Depends => (validate'Result => (header, Frame_length, sequence_number)),
      Post =>
       (if header.Sequence_number > sequence_number and
           (if header.Length <= 34 then Frame_length = 60 else
                  Frame_length = header.Length + Sl3p_frame_size + Ethernet_frame_size) and
                 header.Length <= 1488 and
                   header.Sequence_number > 0 then validate'Result = True else validate'Result = False);


end sl3p;
