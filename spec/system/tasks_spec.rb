require 'rails_helper'

describe 'タスク管理機能', type: :system do
	# ユーザーAとユーザーBを定義
	let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
	let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
	# 作成者がユーザーAであるタスクを定義
	let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

	before do
		# ログイン画面にアクセス
		visit login_path
		# 以下、共通化したいログイン処理
		# メールアドレス・パスワードの入力
		fill_in 'メールアドレス', with: login_user.email
		fill_in 'パスワード', with: login_user.password
		# 「ログインする」ボタンを押す
		click_button 'ログインする'
	end

	# itをまとめる
	shared_examples_for 'ユーザーAが作成したタスクが表示される' do
		it { expect(page).to have_content '最初のタスク' }
	end


	describe '一覧表示機能' do
		context 'ユーザーAがログインしているとき' do
			let(:login_user) { user_a }

			# shared_exampleの呼び出し
			it_behaves_like 'ユーザーAが作成したタスクが表示される'
		end

		context 'ユーザーBがログインしているとき' do
			let(:login_user) { user_b }

			it 'ユーザーAが作成したタスクが表示されない' do
				# ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
				expect(page).to have_no_content '最初のタスク'
			end
		end
	end


	describe '詳細表示機能' do
		context 'ユーザーAがログインしているとき' do
			let(:login_user) { user_a }

			before do
				visit task_path(task_a)
			end

			# shared_exampleの呼び出し
			it_behaves_like 'ユーザーAが作成したタスクが表示される'
		end
	end


	describe '新規作成機能' do
		let(:login_user) { user_a }

		before do
			# 新規作成画面にアクセス
			visit new_task_path
			fill_in '名称', with: task_name
			click_button '登録する'
		end

		context '新規作成画面で名称を入力したとき' do
			let(:task_name) { '新規作成のテストを書く' }

			it '正常に登録される' do
				# have_selectorでCSSセレクタを指定
				expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
			end
		end

		context '新規作成画面で名称を入力しなかったとき' do
			let(:task_name) { '' }

			it 'エラーとなる' do
				within '#error_explanation' do
					expect(page).to have_content '名称を入力してください'
				end
			end
		end
	end
end