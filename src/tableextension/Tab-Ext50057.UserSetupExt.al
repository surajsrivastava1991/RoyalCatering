tableextension 50057 "User Setup Ext" extends "User Setup" //MyTargetTableId
{
    fields
    {
        field(50000; "Unlimited Indent Approval"; Boolean)
        {
            Caption = 'Unlimited Indent Approval';
            DataClassification = CustomerContent;
        }

    }

}