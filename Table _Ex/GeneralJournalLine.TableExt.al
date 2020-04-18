tableextension 50041 "General Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "CL from Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "CL To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Bulk Kitchen"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}