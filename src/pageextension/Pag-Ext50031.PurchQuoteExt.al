pageextension 50031 "Purch. Quote Ext." extends "Purchase Quote"
{
    layout
    {
        addafter(Status)
        {
            field("Ref. Requisition ID"; RecordIDText)
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Ref. Requisition ID';
                ToolTip = 'Table Field';
            }
            field("Quotation Status"; "Quotation Status")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Table Field';
            }
            field("Mail Sent"; "Mail Sent")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Table Field';
            }
        }
        addafter("Order Date")
        {
            field("Last date for Quote Submission"; "Last date for Quote Submission")
            {
                ApplicationArea = All;
                ToolTip = 'Table Field';
            }
        }

    }

    actions
    {
        addafter(Action144)
        {
            action("Quotation Preview")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quotation Preview';
                Image = CompareCost;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'View all related quotations';

                trigger OnAction()
                begin
                    /*
                    PurchHeaderG.Reset();
                    PurchHeaderG.FilterGroup(2);
                    PurchHeaderG.SetRange("Document Type", "Document Type"::Quote);
                    PurchHeaderG.SetRange("Ref. Requisition ID", "Ref. Requisition ID");
                    PurchHeaderG.FilterGroup(0);
                    PurchHeaderG.SetCurrentKey(Amount);
                    PurchHeaderG.SetAscending(Amount, false);
                    PAGE.RunModal(PAGE::"Quotation Preview", PurchHeaderG);
                    */
                    if Format("Ref. Requisition ID") = '' then
                        exit;
                    PurchLine2G.Reset();
                    PurchHeaderG.Reset();
                    PurchHeaderG.SetRange("Ref. Requisition ID", "Ref. Requisition ID");
                    //PurchHeaderG.SetRange("Document Type", "Document Type"::Quote);
                    if PurchHeaderG.FindSet() then
                        repeat
                            PurchLineG.Reset();
                            PurchLineG.SetRange("Document Type", PurchHeaderG."Document Type");
                            PurchLineG.SetRange("Document No.", PurchHeaderG."No.");
                            if PurchLineG.FindSet() then
                                repeat
                                    PurchLine2G := PurchLineG;
                                    PurchLine2G.Mark(true);
                                until PurchLineG.Next() = 0;
                        until PurchHeaderG.Next() = 0;
                    PurchLine2G.MarkedOnly(true);
                    Page.Run(Page::"Quotation Preview", PurchLine2G);

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        RecordIDText := Format("Ref. Requisition ID", 0, 1);
    end;

    var
        PurchHeaderG: Record "Purchase Header";
        PurchLineG: Record "Purchase Line";
        PurchLine2G: Record "Purchase Line";
        RecordIDText: Text[100];

}
