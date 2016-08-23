require 'active_record'

class VehicleBase < ActiveRecord::Base
  establish_connection :oracle

  self.table_name = 'vdmadm.vehicle_base'

end