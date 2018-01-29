package body sl3p
with SPARK_Mode
is

    function validate(header: Sl3p_header; Frame_length: unsigned_32; sequence_number: unsigned_64) return Boolean
    is
        valid: Boolean := header.Sequence_number /= 0;
    begin
        valid := valid and (header.Sequence_number > sequence_number);
        valid := valid and header.Length <= 1488;
        if header.Length <= 34 then
            valid := valid and Frame_length = 60;
        else
            valid := valid and (Frame_length = header.Length + Ethernet_frame_size + Sl3p_frame_size);
        end if;
        return valid;
    end;

end sl3p;
