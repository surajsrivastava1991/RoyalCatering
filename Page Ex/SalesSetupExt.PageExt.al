pageextension 50053 "Sales Setup Ext." extends "Sales & Receivables Setup" //MyTargetPageId
{
    layout
    {
        addlast("Number Series")
        {
            field("BEO Nos."; "BEO Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
            field("Production Plan No."; "Production Plan No.")
            {
                ApplicationArea = all;
                ToolTip = 'Table field';
            }
        }
    }

}