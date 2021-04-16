const loadForm = () => {
  const edit = document.querySelector(".edit-comment");
  const assmatComment = document.querySelector(".assmat-comment");
  const assmatForm = document.querySelector(".assmat-form");
  console.log(edit);

  edit.addEventListener("click", (event) => {
  event.preventDefault();
  console.log(event);
  console.log(event.currentTarget);

  assmatComment.classList.toggle("hidden");
  assmatForm.classList.toggle("hidden");
  });
};

export { loadForm };
