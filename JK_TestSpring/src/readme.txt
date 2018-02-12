		Person person= (Person) context.getBean("person");
		String s =  person.sayHello();
		System.out.println("Ther person say:" + s);