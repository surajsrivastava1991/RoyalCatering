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
    }
}