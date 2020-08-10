codeunit 50005 "PurchPost"
{
    var
        PurchRequisitionG: Record "Purchase Indent Header";
        PurchRequisitionLineG: Record "Purchase Indent Line";
        ReqWorksheertMAkeOrderCUG: Codeunit "Req. Wksh.-Make Order-Mofified";
        FullyReceivedG: Boolean;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptLineInsert', '', true, true)]
    local procedure OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        FullyReceivedG := false;
        if PurchLine.Quantity >= (PurchRcptLine.Quantity) + PurchLine."Quantity Received" then
            FullyReceivedG := true;
        PurchRequisitionLineG.Reset();
        PurchRequisitionLineG.SetRange("Ref. Document Type", PurchRequisitionLineG."Ref. Document Type"::"Purchase Order");
        PurchRequisitionLineG.SetRange("Ref. Document No.", PurchLine."Document No.");
        PurchRequisitionLineG.SetRange("Ref. Document Line No.", PurchLine."Line No.");
        if PurchRequisitionLineG.FindSet() then
            repeat
                if FullyReceivedG then
                    PurchRequisitionLineG."Transaction Status" := PurchRequisitionLineG."Transaction Status"::"Approved-Received"
                else
                    PurchRequisitionLineG."Transaction Status" := PurchRequisitionLineG."Transaction Status"::"Approved-Partially Received";
                PurchRequisitionLineG.Modify(true);
                ReqWorksheertMAkeOrderCUG.UpdateHeaderStatus(PurchRequisitionLineG);
            until PurchRequisitionLineG.Next() = 0;
    end;
}