pageextension 50036 "Purchase Line Archieved Ext." extends "Purchase Quote Archive Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Commercial Specification"; "Commercial Specification")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
            field("Technical Sepcification"; "Technical Sepcification")
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
}