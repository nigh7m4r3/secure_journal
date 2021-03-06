class Entry::Show < Trailblazer::Operation
  # step     :debug!
  step     :find_diary!
  step     :find_entry!
  success :generate_json
  failure :log_errors!

  def debug!(options)
    binding.pry
  end

  def find_diary!(options)
    options['diary'] = options['current_user'].diaries.find_by(id: options['params'][:diary_id])
  end

  def find_entry!(options)
    options['model'] = options['diary'].entries.find_by(id: options['params'][:id])
  end

  def log_errors!(options)
    options['response.status'] = 404
    options['presenter.default'] = {errors: "Not found" }
  end

  def generate_json(options)
    options['response.status'] = 200
    options['presenter.default'] = EntryDecorator.new(options['model']).as_json
  end
end