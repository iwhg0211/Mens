Rails.application.routes.draw do

  namespace :user do
    get 'tags/show'
    get 'tags/create'
  end
  devise_for :admins,skip: [:registrations,:passwords], controllers: {
    sessions: "admin/sessions"
    # ログインのURLを設定
  }
  devise_for :users,skip: [:passwords], controllers: {
    # userのパスワードは必要ないので、skipにしています。
    registrations: "user/registrations",
    # 新規登録のURLを設定
    sessions: "user/sessions"
    # ログインのURLを設定
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    # resourcesはindex,show,new,creste,edit,update,destroyを勝手に設定してくれます
    # only: にすると上記の７種類の中で好きなものだけ設定できます
    resources :posts, only: [:index, :show, :edit, :update] do
      resources :reviews, only: [:index, :show, :edit, :update, :destroy]
    end
    resources :tags, only: [:index, :new, :create, :edit, :update, :destroy]
    get 'tag' => 'tags#tag_index', as: 'tag_index'
    resources :tag_posts, only: [:update]
  end



  scope module: :user do
    root to: "homes#top"
    post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
    get 'about' => 'homes#about', as: 'about'
    resources :users
    resources :posts do
      resources :reviews
    end

    get 'mypage' => 'users#mypage', as: 'mypage'
    patch 'mypage' => 'users#update_mypage', as: 'update_mypage'
    get 'edit_mypage' => 'users#edit_mypage', as: 'edit_mypage'
    get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    # ↑退会確認ページを表示するためのルーティング
    patch '/users/:id/withdraw' => 'users#withdraw', as: 'withdraw'
    # ↑論理削除するためのルーティング、patchにするのが大事
    resources :tags, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'search'
        get 'autocomplete' # この１行を追記
      end
    end
    resources :tag_posts
  end

end