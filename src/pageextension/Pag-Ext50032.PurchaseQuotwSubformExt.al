pageextension 50032 "Purchase Quotw Subform Ext." extends "Purchase Quote Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Technical Sepcification"; "Technical Sepcification")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
            field("Commercial Specification"; "Commercial Specification")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
            field("User Comment"; "User Comment")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
        }
    }

    actions
    {
    }
}