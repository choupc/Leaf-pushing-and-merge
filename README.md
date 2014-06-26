Leaf-pushing-and-merge
======================

binary trie construction and ip lookup with Leaf pushing and merge algorithm


實作方法:
======================

STEP1:
依照Fast binary and multiway prefix searches for packet forwarding此篇論文上所提到leaf pushing and merge演算法實作得到node prefix，此演算法是用inorder traversal的排序方式並且將leaf pushing和merge同時實作。依照演算法實作出來的結果和論文上預期的結果有些不同，實作出來的結果會比預期的結果多出三個node，分別是0x5a, 0xa0, 0xb6。

STEP2:
對STEP1執行產生的node做33bit轉32bit的conversion。
實作方法:
1.	在所有node的don’t care bit插入1，don’t care bit以下的bit全部補0，如此一來原本的32bit prefix就會轉成33bit
2.	再以論文上敘述的rotation方式，分別將不同種case的33bit prefix轉換成32bit

STEP3:
確定程式正確性後，再以IPV4-Prefix-AS6447-2012-02-07.txt作為實際參考資料並進行最後的ip address搜尋效能評估
，並且和Binary_Trie的ip address搜尋效能評估做比較
