tableextension 50060 "Transfer Header Ext." extends "Transfer Header"
{
    fields
    {
        field(50000; "Req. Document No."; Code[50])
        {
            Caption = 'Req. Document No.';
            DataClassification = ToBeClassified;
        }
    }

}