tableextension 50053 "Sales Setup Ext" extends "Sales & Receivables Setup" //MyTargetTableId
{
    fields
    {
        field(50000; "BEO Nos."; Code[20])
        {
            Caption = 'BOE Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

        }
        field(50001; "Production Plan No."; Code[20])
        {
            Caption = 'Production Plan No.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

        }
    }
}