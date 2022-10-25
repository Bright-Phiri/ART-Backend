class AppServices::ResultsUploader < ApplicationService
    attr_reader :blood_type, :hiv_res, :tisuue_res, :conducted_by, :lab_order_id

    def initialize(params)
      @blood_type = params[:blood_type]
      @hiv_res = params[:hiv_res]
      @tisuue_res = params[:tisuue_res]
      @conducted_by = params[:conducted_by]
      @lab_order_id = params[:lab_order_id]
    end

    def call
        upload_lab_order_results
    end

    private
    def upload_lab_order_results
        lab_order = LabOrder.find(lab_order_id)
        if lab_order.verified?
           result = lab_order.result
           raise ExceptionHandler::LabOrderError, "Lab Order Results already added" unless result.nil?
           patient = Patient.find(lab_order.patient_id)
           results = lab_order.create_result(patient_name: patient.full_name, blood_type: lab_order.blood_type, hiv_res: hiv_res, tisuue_res: tisuue_res, conducted_by: conducted_by)
           if results.persisted?
              lab_order.status = "archived"
              lab_order.save(validate: false)
              message1 = "Dear #{patient.full_name}, you're being informed that your test results are ready at the center where the blood samples were taken. therefore, you're requested to come over so that you know your results and get counseling according to the results."
              message2 = "Okondedwa #{patient.full_name}, tafuna tikudziwiseni kuti zotsatila za kuyezedwa kwa magazi anu zafika tsopano ku center komwe munayezedwa magaziko. Muli kupemphedwa kuti mubwere kuti muzamve zotsatilazi komaso kuti mulandire uphungu malingana ndi zotsatilazo."
              test_results = OpenStruct.new(uploaded?: true, results: results, msg1: message1, msg2: message2, patient_phone: patient.phone)
              test_results
           end
        else
           raise ExceptionHandler::LabOrderError, "Lab Order Not verified"
        end
    end
end