const loadForm = () => {
  // select all user-input div
  const userInputs = document.querySelectorAll(".user-input");

  // for each user-input div
  userInputs.forEach((userInput) => {
    const edit = userInput.querySelector(".edit-comment");
    const read = userInput.querySelector(".read");
    const write = userInput.querySelector(".write");

    edit.addEventListener("click", (event) => {
      event.preventDefault();
      read.classList.toggle("hidden");
      write.classList.toggle("hidden");
    });
  });
};

export { loadForm };
