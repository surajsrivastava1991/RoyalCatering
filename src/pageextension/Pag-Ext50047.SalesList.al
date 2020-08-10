pageextension 50047 "Sales List" extends "Sales List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Card)
        {
            action("Open Enquiry Card")
            {
                ApplicationArea = all;
                ToolTip = 'Open Enquiry Card';
                Image = Open;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SalesHeaderL: Record "Sales Header";
                begin
                    SalesHeaderL.get("Document Type", "No.");
                    Page.RunModal(Page::"Banquet Event Order", SalesHeaderL);
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}