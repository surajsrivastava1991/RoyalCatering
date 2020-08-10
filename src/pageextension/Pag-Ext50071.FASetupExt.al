pageextension 50071 "FA Setup Ext" extends "Fixed Asset Setup"
{
    layout
    {
        addlast(General)
        {
            field("Acquired Allowed"; "Acquired Allowed")
            {
                ApplicationArea = all;
                ToolTip = 'Acquired allowed in requisition';
            }
        }
    }

    actions
    {
    }
}