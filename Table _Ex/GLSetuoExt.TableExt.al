tableextension 50023 "GL Setuo Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Project Dimension Code :"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(50001; "PDC Receivable"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50002; "PDC Payable"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50003; "PDC Template Name"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(50004; "PDC Batch Name"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch";
        }
    }
}