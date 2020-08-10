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
        addafter("Report Output Type")
        {
            field("PDC Payable"; "PDC Payable")
            {
                ApplicationArea = all;
                Caption = 'PDC Payable Account';
                ToolTip = 'PDC Payable Account';
            }
            field("PDC Receivable"; "PDC Receivable")
            {
                ApplicationArea = all;
                Caption = 'PDC Receivable Account';
                ToolTip = 'PDC Receivable Account';
            }
            field("PDC Template Name"; "PDC Template Name")
            {
                ApplicationArea = all;
                Caption = 'PDC Template Name';
                ToolTip = 'PDC Template Name';
            }
            field("PDC Batch Name"; "PDC Batch Name")
            {
                ApplicationArea = all;
                Caption = 'PDC Batch Name';
                ToolTip = 'PDC Batch Name';
            }
        }
    }

}