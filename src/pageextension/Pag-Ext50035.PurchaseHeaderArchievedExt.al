pageextension 50035 "Purchase Header Archieved Ext." extends "Purchase Quote Archive"
{
    layout
    {
        addafter(Status)
        {
            field("Quotation Status"; "Quotation Status")
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
            field("Ref. Requisition ID"; RefReqID)
            {
                ApplicationArea = All;
                ToolTip = 'Table Fields';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        RefReqID := Format("Ref. Requisition ID", 0, 1);

    end;

    var
        RefReqID: Text[100];
}