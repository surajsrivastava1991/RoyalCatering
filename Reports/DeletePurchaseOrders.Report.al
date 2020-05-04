report 50052 "Delete Purchase Orders"
{
    Caption = 'Dalete Purchase Orders';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            trigger OnAfterGetRecord()
            begin
                Flag1G := false;
                PurchaseHeaderG.get(PurchaseHeader."Document Type", PurchaseHeader."No.");
                PurchaseLineG.Reset();
                PurchaseLineG.SetRange("Document Type", "Document Type");
                PurchaseLineG.SetRange("Document No.", "No.");
                if PurchaseLineG.FindSet() then
                    repeat
                        PurchaseLineG.LockTable();
                        IF (PurchaseLineG.Quantity > (PurchaseLineG."Quantity Invoiced" + PurchaseLineG."Qty under delivery" + PurchaseLineG."Exceed Qty.")) then
                            Flag1G := true;
                    until PurchaseLineG.Next() = 0;
                if not Flag1G then begin
                    ArchiveManagementG.ArchivePurchDocument(PurchaseHeaderG);
                    PurchaseHeaderG.Delete(TRUE);
                end;
                //MESSAGE(PurchaseHeaderG."No.");
            end;
        }
    }
    var
        PurchaseHeaderG: Record "Purchase Header";
        PurchaseLineG: Record "Purchase Line";
        ArchiveManagementG: Codeunit ArchiveManagement;
        Flag1G: Boolean;
}