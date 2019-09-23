# 開発環境
# rake jobs:check[max_age]  # max_age秒より古いジョブがまだ試行されていない場合、エラーステータスで終了します
# rake jobs:clear           # Delayed Job のキューをクリアな状態にする
# rake jobs:work            # Delayed Job ワーカーを起動させる
# rake jobs:workoff         # Delayed Job ワーカーを起動させ、すべてのジョブが完了したら終了する

# 本番環境
# 別々のプロセス内で2つのワーカーを走らせる
# RAILS_ENV=production bin/delayed_job -n 2 start
# ワーカーを停止させる
# RAILS_ENV=production bin/delayed_job stop
# ワーカーを再起動させる(ワーカー数は2つ)
# RAILS_ENV=production bin/delayed_job -n 2 restart


# 失敗したジョブを消さない
Delayed::Worker.destroy_failed_jobs = false
# Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

# リトライしない
Delayed::Worker.max_attempts = 0

# エラーがあった場合に Exception Notification で通知するプラグインを作る
class DelayedJobExceptionNotificationPlugin < Delayed::Plugin
  callbacks do |lifecycle|
    lifecycle.around(:invoke_job) do |job, *args, &block|
      begin
        block.call(job, *args)
      rescue Exception => exception
        # ActiveRecord::RecordNotFound などでも通知するために
        ignored_exceptions = ExceptionNotifier.ignored_exceptions
        ExceptionNotifier.ignored_exceptions = []
        begin
          ExceptionNotifier.notify_exception(exception,
                                             data: { job: job.inspect })
        ensure
          ExceptionNotifier.ignored_exceptions = ignored_exceptions
        end
        raise
      end
    end
  end
end
# プラグインを登録する
Delayed::Worker.plugins << DelayedJobExceptionNotificationPlugin