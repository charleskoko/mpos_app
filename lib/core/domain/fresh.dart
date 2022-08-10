class Fresh<T> {
  final bool isFresh;
  final T entity;

  Fresh.yes(this.entity) : isFresh = true;
  Fresh.no(this.entity) : isFresh = false;
}
