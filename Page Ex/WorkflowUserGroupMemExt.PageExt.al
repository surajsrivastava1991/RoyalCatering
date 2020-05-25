pageextension 50048 "Workflow User Group Mem. Ext" extends "Workflow User Group Members"
{
    layout
    {
        addlast(Group)
        {
            field(Purchaser; Purchaser)
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
        }
    }
}