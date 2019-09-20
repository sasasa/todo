json.extract! task, :id, :content, :finished, :due_on, :created_at, :updated_at
json.url task_url(task, format: :json)
