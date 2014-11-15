module Menu::PartitionsHelper
  def partition_name(partition)
    t('menu.partitions.partition_num', num: "##{partition.id}")
  end
end
