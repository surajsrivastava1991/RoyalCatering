tableextension 50092 "GL Account" extends "G/L Account"
{
    fields
    {
        field(50000; "Fee/Charge Type"; Option)
        {
            Caption = 'Fee/Charge Type';
            DataClassification = CustomerContent;
            OptionMembers = " ","Tourism Fee","Muncipility Fee","Other Charge";
            OptionCaption = ' ,Tourism Fee,Muncipility Fee,Other Charge';
        }
    }

    var
        myInt: Integer;
}