tableextension 50060 "Transfer Header Ext." extends "Transfer Header"
{
    fields
    {
        field(50000; "Req. Document No."; Code[50])
        {
            Caption = 'Req. Document No.';
            DataClassification = CustomerContent;
        }
        field(50001; "Total Unit Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Transfer Line"."Total Amount" where("Document No." = field("No.")));
            Editable = false;
        }
    }

}