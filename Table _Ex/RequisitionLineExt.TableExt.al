tableextension 50059 "Requisition Line Ext" extends "Requisition Line"
{
    fields
    {
        field(50000; "Req. Document No."; Code[20])
        {
            Caption = 'Req. Document No.';
            DataClassification = CustomerContent;
        }
        field(50001; "Req. Line No."; Integer)
        {
            Caption = 'Req. Line No.';
            DataClassification = CustomerContent;
        }
        field(50002; "From Request"; Boolean)
        {
            Caption = 'From Request';
            DataClassification = CustomerContent;
        }
        field(50003; "Vendor Trade Agreement"; Boolean)
        {
            Caption = 'Vendor Trade Agreement';
            DataClassification = CustomerContent;
        }
    }

}