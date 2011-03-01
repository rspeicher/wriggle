require 'fileutils'

module TemporaryFiles
  def self.path
    File.expand_path("../../../tmp", __FILE__)
  end

  def self.setup
    path = self.path

    files = %w(app/views/wishlists/index.html.haml
    app/views/shared/_moderation.html.haml
    app/views/shared/_maintitle.html.haml
    app/views/shared/_form_errors.html.haml
    app/views/shared/_contextual_search.html.haml
    app/views/members/wishlists/update.js.rjs
    app/views/members/wishlists/new.html.haml
    app/views/members/wishlists/index.lua.erb
    app/views/members/wishlists/index.html.haml
    app/views/members/wishlists/edit.html.haml
    app/views/members/wishlists/create.js.rjs
    app/views/members/wishlists/_wishlist_row.html.haml
    app/views/members/wishlists/_form.html.haml
    app/views/members/show.html.haml
    app/views/members/new.html.haml
    app/views/members/index.lua.erb
    app/views/members/index.html.haml
    app/views/members/edit.html.haml
    app/views/members/_form.html.haml
    app/views/layouts/application.lua.erb
    app/views/layouts/application.html.haml
    app/views/items/show.html.haml
    app/views/items/new.html.haml
    app/views/items/index.html.haml
    app/views/items/edit.html.haml
    app/views/items/_form.html.haml
    app/sweepers/index_sweeper.rb
    app/models/zone.rb
    app/models/wishlist.rb
    app/models/user_session.rb
    app/models/user.rb
    app/models/session.rb
    app/models/raid.rb
    app/models/member_rank.rb
    app/models/member.rb
    app/models/loot_table.rb
    app/models/loot.rb
    app/models/live_raid.rb
    app/models/live_loot.rb
    app/models/live_attendee.rb
    app/models/item_price.rb
    app/models/item.rb
    app/models/completed_achievement.rb
    app/models/boss.rb
    app/models/attendee.rb
    app/models/achievement.rb
    app/helpers/members_helper.rb
    app/helpers/members/wishlists_helper.rb
    app/helpers/items_helper.rb
    app/helpers/application_helper.rb
    app/controllers/wishlists_controller.rb
    app/controllers/user_sessions_controller.rb
    app/controllers/searches_controller.rb
    app/controllers/members_controller.rb
    app/controllers/members/wishlists_controller.rb
    app/controllers/items_controller.rb
    app/controllers/application_controller.rb)

    files.each do |file|
      file = File.join(path, file)
      FileUtils.mkdir_p(File.dirname(file))
      FileUtils.touch(file)
    end
  end

  def self.teardown
    FileUtils.rm_rf(self.path)
  end
end
