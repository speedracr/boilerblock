class PagesController < ApplicationController
  def index
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'

    client = Storyblok::Client.new(
      cache_version: Time.now.to_i,
      token: Rails.application.credentials.storyblok[:preview_token],
      version: 'draft'
    )

    assigns = {
      story: client.story(params[:path])['data']['story']
    }

    Liquid::Template.file_system = Liquid::LocalFileSystem.
      new('app/views/components')
    template = Liquid::Template.parse(File.read('app/views/layouts/page.liquid'))
    render html: template.render!(assigns.stringify_keys, {}).html_safe
  end
end
