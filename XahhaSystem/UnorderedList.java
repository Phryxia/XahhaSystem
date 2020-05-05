import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

/*
  UnorderedList is my proejct optimized data structure.
  
  This is effective when middle element can be removed.
  Also this supports multiple removing simultaneosouly.
  
  Elements in this list doesn't have specific order.
  For example, when rendering particles ordering is
  not matter.
*/
public class UnorderedList <T>
{
  private int size;
  private int capacity;
  
  private Object[] data;
  
  public UnorderedList()
  {
    size     = 0;
    capacity = 16;
    
    data = new Object[capacity];
  }
  
  public UnorderedList(int init_capacity)
  {
    size     = 0;
    capacity = init_capacity;
    
    data = new Object[capacity];
  }
  
  public void reserve()
  {
    Object[] new_data = new Object[capacity * 2];
    System.arraycopy(data, 0, new_data, 0, size);
    data = new_data;
    capacity *= 2;
  }
  
  /*
    Add element in the list.
  */
  public void add(T element)
  {
    // Check the capcity first and do reservation if needed
    if(size >= capacity)
    {
      reserve();
    }
    
    data[size] = element;
    ++size;
  }
  
  /*
    Remove element on index logically.
    Physically removing will be performed by G.C.
  */
  public void remove(int index)
  {
    // If the element you want to remove is in the middle
    // then swap with the last element to removing point
    data[index] = data[size-1];
    --size;
  }
  
  /*
    Remove multiple objects in simultanesouly.
    It removes 'larger index' first because lower
    index may corrupt other remove-waiting indexes.
  */
  public void remove(ArrayList <Integer> queue)
  {
    // Sort in descending order
    Collections.sort(queue, new Comparator <Integer> () {
      public int compare(Integer x, Integer y)
      {
        return y.compareTo(x);
      }
    });
    
    // Remove one by one
    for(Integer i : queue)
    {
      remove(i);
    }
  }
  
  /*
    Get data on index
  */
  public T get(int index)
  {
    return (T)data[index];
  }
  
  public int size()
  {
    return size;
  }
  
  public int capacity()
  {
    return capacity;
  }
}
