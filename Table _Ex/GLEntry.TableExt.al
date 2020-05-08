tableextension 50043 "GL Entry" extends "G/L Entry"
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
        field(50003; "Batch Description"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}