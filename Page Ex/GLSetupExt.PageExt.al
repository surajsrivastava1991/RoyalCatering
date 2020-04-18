pageextension 50024 "GL Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Project Dimension Code :"; "Project Dimension Code :")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
        }
    }

}