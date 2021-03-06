class Diary::Create < Trailblazer::Operation

  step     Model( Diary, :new )
  step     Contract::Build(constant: Diary::Contract::DiaryForm)
  step     Contract::Validate( key: :diary )
  failure  :log_error!
  step     Contract::Persist(  )

  success :generate_json
  failure :log_error!

  def log_error!(options)
    options['response.status'] = 422
    options['presenter.default'] = {errors: options['contract.default'].errors.messages }
  end

  def generate_json(options)
    options['response.status'] = 201
    options['presenter.default'] = DiaryDecorator.new(options['model']).to_json
  end
end