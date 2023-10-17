public class Item {
	private String name;
	private double totalAmount;
	private String payee;
	private String[] payers;
	
	public Item(String name,double totalAmount, String payee, String[] payers) {
		this.name = name;
		this.totalAmount = totalAmount;
		this.payee = payee;
		this.payers = payers;
	}
	
	public String getName() {
		return name;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public String getPayee() {
		return payee;
	}
	
//	TODO: §â¸ê®Æ«¬ºA§ï¦¨String
	public String getpayers() {
		String payerList = "";
		for (int i = 0; i < payers.length; i++) {
			payerList = payerList + payers[i] + " ";
		}
		return payerList;
	}
	
	public int getPayersNum() {
		return payers.length;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public void setPayee(String name) { 
		this.payee = name;
	}

	public void setPayer(String[] payer) {
		this.payers = payer;
	}
}

