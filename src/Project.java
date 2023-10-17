import java.util.ArrayList;

public class Project {
	private String name;
	private JointAccount jointAccount;
//	TODO: 是不是allItems allUsers比較好
	private ArrayList<Item> allItem = new ArrayList<Item>();
	private ArrayList<UserAccount> allUser = new ArrayList<UserAccount>();

	public Project(String name, JointAccount jointAccount) {
		this.name = name;
		this.jointAccount = jointAccount;
	}

	public void addItem(String itemName, double totalAmount, String payee, String payer) {
		if (payer.equals("all") || payer.equals("ALL") || payer.equals("All")) {
			payer = getAllUser();
		}
		String payerList[] = payer.split(" ");
		for (String user: payerList) {
//			TODO: 如果輸入不存在的user會自動新增、排除NA
			if (!getAllUser().contains(user) && !user.equals("NA")) {
				this.addUser(user);
			}
		}
		Item item = new Item(itemName, totalAmount, payee, payerList);
		allItem.add(item);
//		TODO: 我加了線線
		System.out.println("--- Item " + itemName + " is added to " + this.name + "! ---");
		System.out.println();
	}

//	TODO: 改成void
	public void getAllItem() {
		System.out.printf("%-8s %-20s %-10s %-15s %-50s", "Index", "Item", "Amount", "Who_paid", "participants");
		System.out.println();
		for (Item i : allItem) {
			System.out.format("%-8s %-20s %-10s %-15s %-50s",
					allItem.indexOf(i), i.getName(), i.getTotalAmount(), i.getPayee(), i.getpayers());
            System.out.println();
		}
	}

	public void addUser(String name) {
		UserAccount user = new UserAccount(name, 0.0);
		allUser.add(user);
	}

//	TODO:　我新增的
	public String getAllUser() {
		String nameList = "";
		for (UserAccount user : allUser) {
			nameList = nameList + user.getName() + " " ;
		}
		return nameList;
	}

//	TODO: 我新增的
	public void revise(int index, int function, String newContet) {
		Item revise = allItem.get(index);
		switch (function) {
		case 1:
//			1-修改 item name；
			revise.setName(newContet);
			break;
		case 2:
//			2-修改金額；
			double d = Double.parseDouble(newContet);
			revise.setTotalAmount(d);
			break;
		case 3:
//			3-修改收款人；
			revise.setPayee(newContet);
			break;
		case 4:
//			4-修改付款人；
			String payer[] = newContet.split(" ");
			revise.setPayer(payer);
			break;
		}
		System.out.println("Item " + revise.getName() + " is revised!");
		System.out.println();
	}

//	TODO: 我新增的
	public void revise(int index, int function) {
//		5-刪除 item
		Item revise = allItem.get(index);
		allItem.remove(revise);
		System.out.println("Item " + revise.getName() + " is deleted!");
		System.out.println();
	}

	public void calculation() {
		for(Item item: allItem) {
			double totalAmount = item.getTotalAmount();
			double amount = totalAmount / item.getPayersNum();
			for (UserAccount user : allUser) {
				String userName = user.getName();
				if (userName.equals(item.getPayee())) {
					user.addMoney(totalAmount);
				}
				if (item.getpayers().contains(userName)) {
					user.oweMoney(amount);
				}
			}
			if (item.getPayee().equals("JointAccount")) {
				jointAccount.spend(amount);
			}
		}
		for(UserAccount user : allUser) {
			double money = user.getTotalAmount();
			if (money > 0) {
				System.out.printf(user.getName() + " gets " + money);
				System.out.println("");
			} else if (money < 0) {
				System.out.printf(user.getName() + " owes " + Math.abs(money));
				System.out.println("");
			}
		}
		System.out.print("Joint Account balance: " + jointAccount.getTotalAmount());
	}
}

