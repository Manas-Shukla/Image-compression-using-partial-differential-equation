rm -r compressed
mkdir compressed
for i in {1..5};do pbmtojbg m_im$i.pbm ./compressed/m_im$i.jbg ;done
for i in {1..5};do zpaq pa ./compressed/im$i.archive  ./compressed/m_im$i.jbg res_im$i.png ;done


