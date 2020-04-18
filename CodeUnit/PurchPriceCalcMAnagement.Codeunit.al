codeunit 50053 "Purch. Price Calc MAnagement"
{
    var
        TempPurchPriceG: record "Purchase Price" temporary;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Price Calc. Mgt.", 'OnAfterFindPurchLinePrice', '', true, true)]
    local procedure OnAfterFindPurchLinePrice(var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header"; var PurchasePrice: Record "Purchase Price"; CalledByFieldNo: Integer)
    begin
        FindPurchPrice(TempPurchPriceG, PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine."Unit of Measure Code", PurchaseLine."Currency Code", PurchaseLine."Order Date", false);
        TempPurchPriceG.Reset();
        TempPurchPriceG.SetRange(TempPurchPriceG."Direct Unit Cost", PurchaseLine."Direct Unit Cost");
        if TempPurchPriceG.Find('-') then
            PurchaseLine."Vendor Trade Agreement" := true
        else
            PurchaseLine."Vendor Trade Agreement" := false;
    end;

    procedure FindPurchPrice(var ToPurchPriceP: Record "Purchase Price"; VendorNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; UOM: Code[20]; CurrencyCode: Code[20]; StartingDate: Date; ShowAll: Boolean)
    var
        FromPurchPrice: Record "Purchase Price";
    begin
        with FromPurchPrice do begin
            SetRange("Item No.", ItemNo);
            SetRange("Vendor No.", VendorNo);
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToPurchPriceP.Reset();
            ToPurchPriceP.DeleteAll();
            if Find('-') then
                repeat
                    ToPurchPriceP := FromPurchPrice;
                    ToPurchPriceP.Insert();
                until Next() = 0;
        end;
    end;
}