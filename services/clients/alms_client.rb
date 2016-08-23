class ALMSClient < Stir::SoapClient
  response(:work_order) { response.body[:add_listing_response][:work_order_number].to_i }

  def request_work_order(vin)
    add_listing({message: {
        auctionId: ENV['TAZA_ENV'] == 'qa' ? 'QLM1' : 'AAA',
        vin: vin,
        sellerNumber: ENV['TAZA_ENV'] == 'qa' ? 4903763 : 4985126,
        user: 'VIC',
        skip_legacy_vin_decode: true,
        listing_info: {vehicle_status: 'Recon Inventory'},
        transport_info: {transport_method: 'Customer Drop'}
    }
                })
  end

end
