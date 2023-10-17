import java.util.Scanner;

public class Tester {
	public static void main(String[] args) {
		Scanner Scanner = new Scanner(System.in);
		System.out.print("Project Name: ");
		String p = Scanner.nextLine();
		System.out.print("Participants (separate by space): ");
		String name[] = Scanner.nextLine().split(" ");
		System.out.print("Joint account money: ");
		double JAamount = Scanner.nextInt();
		Scanner.nextLine();
		JointAccount jointAccount = new JointAccount(JAamount);
		Project project = new Project(p,jointAccount);
		for (int i = 0; i < name.length; i++) {
			project.addUser(name[i]);
		}
		

		int function = -1;
		while (function != 0) {
			System.out.print("1- Add item/2- View existing items/3- Revise or delete item/4- Add user/5- View existing users/6- Replenish joint account/0- Calculate result\r\n"
							+ "Enter action number: ");
			function = Scanner.nextInt();
			Scanner.nextLine();
//			TODO: 我加了線線
			System.out.println("-".repeat(40));
			switch (function) {
			case 1:
				String payer = "";
				System.out.print("Item name: ");
				String itemName = Scanner.nextLine();
				System.out.print("Amount: ");
				Double amount = Scanner.nextDouble();
				Scanner.nextLine();
				System.out.print("Who paid (if paid from joint account, enter *): ");
				String payee = Scanner.nextLine();
				if (payee.equals("*")) {
					payee = "JointAccount";
					payer = "NA";
				} else {
					System.out.print("Participants of this activity (if every one, enter “all”): ");
					payer = Scanner.nextLine();
				}
				project.addItem(itemName, amount, payee, payer);
				break;
			case 2:
				// View existing items
				project.getAllItem();
				System.out.println();
				break;
			case 3:
				// Revise or delete item
				project.getAllItem();
				System.out.print("Item to revise (enter index number): ");
				int itemIndex = Scanner.nextInt();
				Scanner.nextLine();
				System.out.print("What to revise (1- item/2- amount/3- who paid/4- participants/5- delete item): ");
				int reviseFunction = Scanner.nextInt();
				Scanner.nextLine();
				if (reviseFunction == 5) {
					project.revise(itemIndex, reviseFunction);
				} else {
					System.out.print("New content: ");
					String newContent = Scanner.nextLine();
					project.revise(itemIndex, reviseFunction, newContent);
				}
				break;
			case 4:
				// Add user
				System.out.print("New participants (separate by space): ");
				name = Scanner.nextLine().split(" ");
				for (int i = 0; i < name.length; i++) {
					project.addUser(name[i]);
				}
				break;
			case 5:
				// View existing users
				System.out.println(project.getAllUser());
				System.out.println();
				break;
			case 6:
				//Replenish joint account
				System.out.print("How much do you want to add: ");
				double replenish = Scanner.nextInt();
				Scanner.nextLine();
				jointAccount.addMoney(replenish);
				break;
			case 0:
				// Calculate result
				project.calculation();
				break;
			}
		}
		Scanner.close();

