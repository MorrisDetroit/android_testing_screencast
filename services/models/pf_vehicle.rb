require 'active_record'

class PFVehicle < ActiveRecord::Base
  establish_connection :as400

  self.table_name = 'MACSF.PFVEHICLE'

  alias_attribute :work_order_number, :'swo#'
  alias_attribute :year, :scaryr
  alias_attribute :mileage, :smiles
  alias_attribute :sblu, :sblu
  alias_attribute :subseries, :'ssubse'

  {status: :scode,
   make: :smake,
   model: :smodel,
   model15: :smod15,
   subseries: :ssubse,
   body: :sbody,
   engine: :seng,
   sab: :sab,
   sbags: :sbags,
   air_conditioning_code: :sac,
   brakes_code: :spb,
   cruise_control_code: :scc,
   interior_covering_code: :sint,
   power_locks_code: :sel,
   power_steering_code: :sps,
   power_windows_code: :sew,
   radio_code: :sradio,
   rear_defroster_code: :srdefr,
   roof_code: :stop,
   tilt_steering_code: :stilt,
   transmission_code: :strn,
   drivetrain: :s4x4,
   interior_color: :sintco,
   exterior_color: :scolor,
   engine_liter: :sadjusr
  }.each do |method, field|
    define_method(method) do
      read_attribute(field).strip
    end
  end

  def vin
    "#{sser1s}#{sser2n}#{sser3t}#{sser4t}#{sser5t}#{sser6t}#{sser7t}#{sser8t}#{ssercd}#{ssermy}#{sser11}#{sserl6}"
  end

end
