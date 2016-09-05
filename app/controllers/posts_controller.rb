class PostsController < ApplicationController

  def index
    post_create
    @posts = Post.all.order("date DESC").page(params[:page]).per(20)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
  end

  private
  def post_create
    agent = Mechanize.new 
    page = agent.get("http://b.hatena.ne.jp/entrylist?sort=hot")
    elements = page.search('.box1_1 .hb-entry-link-container a') if page.search('.hb-entry-link-container a')
    images =  page.search('.box1_1 .description') if page.search('.box1_1 .description')  
    dates = page.search('.box1_1 .date') if page.search('.box1_1 .date')

    elements.zip(images,dates).each do |ele, image, date|
      title = ele.inner_text
      image_url = ele.get_attribute('href')
      date = date.inner_text if date.present?
        image_p = image.at('img') if image.at('img')
        if image_p.present?
          image_p_url = image_p.get_attribute('src')
        else
          image_text = image.at('blockquote') if image.at('blockquote')
          image_text = image_text.inner_text if image_text.present?
        end
      post = Post.where(title: title).first_or_initialize
      post.image_url = image_url 
      post.date = date
      post.image = image_p_url
      post.picktext = image_text
      post.save
    end
  end

end
