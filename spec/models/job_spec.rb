require 'rails_helper'

RSpec.describe Job, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:job)).to be_valid
    end

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:job_type) }
    it { should validate_presence_of(:location) }

    it { should have_rich_text(:description) }

    it do
      should define_enum_for(:status)
        .with_values(
          draft: 'draft',
          open: 'open',
          closed: 'closed'
        )
        .backed_by_column_of_type(:string)
    end

    it do
      should define_enum_for(:job_type)
        .with_values(
          full_time: 'full_time',
          part_time: 'part_time'
        )
        .backed_by_column_of_type(:string)
    end
  end

  context 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:applicants).dependent(:destroy) }
  end

  context 'scopes and class methods' do
    let(:account) { FactoryBot.create(:account) }
    let(:other_account) { FactoryBot.create(:account) }

    let!(:software_engineer_job) do
      FactoryBot.create(:job,
                        account: account,
                        status: 'draft',
                        title: 'Sofware Engineer')
    end
    let!(:backend_developer_job) do
      FactoryBot.create(:job,
                        account: account,
                        status: 'open',
                        title: 'Backend Developer')
    end
    let!(:fullstack_developer_job) do
      FactoryBot.create(:job,
                        account: other_account,
                        status: 'closed',
                        title: 'Fullstack Developer')
    end

    describe '.for_account' do
      it 'returns the jobs within account' do
        expect(Job.for_account(account)).to contain_exactly(software_engineer_job, backend_developer_job)
      end

      it 'does not return any job when account is not present' do
        expect(Job.for_account(nil)).to be_blank
      end
    end

    describe '.for_status' do
      it 'returns the jobs with particular status' do
        expect(Job.for_status('open')).to contain_exactly(backend_developer_job)
      end

      it 'returns all jobs when status value is not present' do
        expect(Job.for_status(nil)).to contain_exactly(software_engineer_job, backend_developer_job,
                                                       fullstack_developer_job)
      end
    end

    describe '.search' do
      it 'returns the jobs by searching a keyword on title' do
        expect(Job.search('Developer')).to contain_exactly(backend_developer_job, fullstack_developer_job)
      end

      it 'returns the jobs by prefix keyword on first word of title' do
        expect(Job.search('full')).to contain_exactly(fullstack_developer_job)
      end

      it 'returns the jobs by prefix keyword on any word of title' do
        expect(Job.search('dev')).to contain_exactly(backend_developer_job, fullstack_developer_job)
      end

      it 'returns all jobs when keyword is not present' do
        expect(Job.search(nil)).to contain_exactly(software_engineer_job, backend_developer_job,
                                                   fullstack_developer_job)
      end

      it 'does not return any job when theres no prefix keyword searched on title' do
        expect(Job.search('React')).to be_blank
      end
    end

    describe '.sorted' do
      it 'returns the jobs by created at ascending order' do
        expect(Job.sorted('created_at-asc')).to eq [software_engineer_job, backend_developer_job,
                                                    fullstack_developer_job]
      end

      it 'returns the jobs by created at descending order' do
        expect(Job.sorted('created_at-desc')).to eq [fullstack_developer_job, backend_developer_job,
                                                     software_engineer_job]
      end

      it 'returns the jobs by title ascending order' do
        expect(Job.sorted('title-asc')).to eq [backend_developer_job, fullstack_developer_job, software_engineer_job]
      end

      it 'returns the jobs by title descending order' do
        expect(Job.sorted('title-desc')).to eq [software_engineer_job, fullstack_developer_job, backend_developer_job]
      end

      it 'returns the jobs by created at ascending order when sort value is not present' do
        expect(Job.sorted(nil)).to eq [software_engineer_job, backend_developer_job, fullstack_developer_job]
      end
    end

    describe '.apply_sort' do
      it 'returns the jobs by created at ascending order' do
        expect(Job.apply_sort('created_at-asc')).to eq [software_engineer_job, backend_developer_job,
                                                        fullstack_developer_job]
      end

      it 'returns the jobs by created at descending order' do
        expect(Job.apply_sort('created_at-desc')).to eq [fullstack_developer_job, backend_developer_job,
                                                         software_engineer_job]
      end

      it 'returns the jobs by title ascending order' do
        expect(Job.apply_sort('title-asc')).to eq [backend_developer_job, fullstack_developer_job,
                                                   software_engineer_job]
      end

      it 'returns the jobs by title descending order' do
        expect(Job.apply_sort('title-desc')).to eq [software_engineer_job, fullstack_developer_job,
                                                    backend_developer_job]
      end

      it 'does not return any job when sort value is not present' do
        expect(Job.apply_sort(nil)).to be_blank
      end
    end

    describe '.filter' do
      it 'returns the jobs by filtered values' do
        filter_params = {
          'sort' => 'created_at-desc',
          'status' => '',
          'query' => 'Dev'
        }

        expect(Job.filter(filter_params)).to eq [fullstack_developer_job, backend_developer_job]
      end
    end
  end
end
